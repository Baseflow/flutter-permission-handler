// Selects which flavor's permissions the Swift Package Manager build compiles.
//
// Usage:
//   dart run permission_handler_apple:select <flavor>
//   dart run permission_handler_apple:select --list
//
// A Swift package manifest is evaluated once per package resolution and is given
// none of Xcode's build settings, so it cannot know which build configuration is
// running. The flavor therefore has to be chosen before the build, which is what
// this command does: it records the choice and clears the caches that would
// otherwise keep serving the previous flavor's macros.

import 'dart:convert';
import 'dart:io';

const _configName = 'permission_handler.json';
const _selectionPath = 'ios/Flutter/permission_handler.selected';

/// Caches that keep a previously evaluated manifest alive.
///
/// Xcode does not re-evaluate a package manifest when an environment variable or
/// the selection file changes — only when these are gone. Clearing
/// `SourcePackages` on its own is not enough; the resolved build description in
/// `XCBuildData` pins the old settings too.
const _derivedDataSubpaths = [
  'SourcePackages',
  'Build/Intermediates.noindex/XCBuildData',
];

void main(List<String> args) {
  final flags = <String, String>{};
  final positional = <String>[];
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--list') {
      flags['list'] = 'true';
    } else if (arg.startsWith('--app=')) {
      flags['app'] = arg.substring(6);
    } else if (arg.startsWith('--derived-data=')) {
      flags['derived-data'] = arg.substring(15);
    } else if (arg == '--help' || arg == '-h') {
      stdout.writeln(_usage);
      return;
    } else if (arg.startsWith('-')) {
      _fail('Unknown option "$arg".\n\n$_usage');
    } else {
      positional.add(arg);
    }
  }

  final appRoot = _findAppRoot(flags['app']);
  final configFile = File('${appRoot.path}/$_configName');
  if (!configFile.existsSync()) {
    _fail('No $_configName found in ${appRoot.path}.\n\n'
        'Create one to describe your flavors:\n$_exampleConfig');
  }

  final flavors = _readFlavors(configFile);

  if (flags.containsKey('list')) {
    stdout.writeln('Flavors declared in ${configFile.path}:');
    for (final entry in flavors.entries) {
      final exists = File('${appRoot.path}/${entry.value}').existsSync();
      stdout.writeln('  ${entry.key.padRight(12)} ${entry.value}'
          '${exists ? '' : '   (missing!)'}');
    }
    return;
  }

  if (positional.length != 1) {
    _fail('Expected exactly one flavor name.\n\n$_usage');
  }
  final flavor = positional.single;

  final relativePlist = flavors[flavor];
  if (relativePlist == null) {
    _fail('Flavor "$flavor" is not declared in ${configFile.path}.\n'
        'Known flavors: ${flavors.keys.join(', ')}');
  }

  final plist = File('${appRoot.path}/$relativePlist');
  if (!plist.existsSync()) {
    _fail('Flavor "$flavor" points at $relativePlist, which does not exist.');
  }

  final selection = File('${appRoot.path}/$_selectionPath');
  selection.parent.createSync(recursive: true);
  selection.writeAsStringSync('$flavor\n');

  final cleared = _clearCaches(appRoot, flags['derived-data']);

  stdout.writeln('Selected flavor "$flavor" ($relativePlist).');
  stdout.writeln('');
  stdout.writeln('Permissions that will be compiled in:');
  final descriptions = _usageDescriptions(plist);
  if (descriptions.isEmpty) {
    stdout.writeln('  (none — $relativePlist declares no usage descriptions)');
  } else {
    for (final key in descriptions) {
      stdout.writeln('  $key');
    }
  }
  stdout.writeln('');
  stdout.writeln(cleared.isEmpty
      ? 'No package caches needed clearing.'
      : 'Cleared ${cleared.length} cache location(s) so the manifest is '
          're-evaluated on the next build.');
}

/// Walk up looking for a Flutter app: a pubspec.yaml next to an Xcode project.
Directory _findAppRoot(String? override) {
  var dir = Directory(override ?? Directory.current.path).absolute;
  for (var i = 0; i < 12; i++) {
    final hasPubspec = File('${dir.path}/pubspec.yaml').existsSync();
    final iosDir = Directory('${dir.path}/ios');
    final hasProject = iosDir.existsSync() &&
        iosDir.listSync().any((e) => e.path.endsWith('.xcodeproj'));
    if (hasPubspec && hasProject) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  _fail('Could not find a Flutter app (a pubspec.yaml next to ios/*.xcodeproj) '
      'from ${override ?? Directory.current.path}. Pass --app=<path>.');
}

/// flavor -> Info.plist path, relative to the app root.
Map<String, String> _readFlavors(File configFile) {
  final Object? decoded;
  try {
    decoded = jsonDecode(configFile.readAsStringSync());
  } on FormatException catch (e) {
    _fail('${configFile.path} is not valid JSON: ${e.message}');
  }

  if (decoded is! Map<String, dynamic>) {
    _fail('${configFile.path} must contain a JSON object.');
  }
  final flavors = decoded['flavors'];
  if (flavors is! Map<String, dynamic> || flavors.isEmpty) {
    _fail('${configFile.path} declares no "flavors".\n\n$_exampleConfig');
  }

  final result = <String, String>{};
  flavors.forEach((name, value) {
    if (value is Map<String, dynamic> && value['infoPlist'] is String) {
      result[name] = value['infoPlist'] as String;
    } else {
      _fail('Flavor "$name" in ${configFile.path} has no "infoPlist" string.');
    }
  });
  return result;
}

List<String> _usageDescriptions(File plist) {
  final matches = RegExp(r'<key>(NS\w*UsageDescription)</key>')
      .allMatches(plist.readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet()
      .toList()
    ..sort();
  return matches;
}

/// Remove the caches pinning the previously resolved manifest.
List<String> _clearCaches(Directory appRoot, String? derivedDataOverride) {
  final cleared = <String>[];

  void remove(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) return;
    dir.deleteSync(recursive: true);
    cleared.add(path);
  }

  final home = Platform.environment['HOME'];
  if (home != null) {
    remove('$home/Library/Caches/org.swift.swiftpm/manifests');
  }

  for (final derivedData in _derivedDataDirs(appRoot, derivedDataOverride)) {
    for (final sub in _derivedDataSubpaths) {
      remove('${derivedData.path}/$sub');
    }
  }

  return cleared;
}

/// Locate the DerivedData directories belonging to this app.
///
/// Every Flutter app's Xcode project is called `Runner`, so matching on the
/// directory name would clear unrelated apps' caches. Each DerivedData
/// directory records the workspace it belongs to in its `info.plist`; match on
/// that instead.
List<Directory> _derivedDataDirs(Directory appRoot, String? override) {
  if (override != null) return [Directory(override)];

  final home = Platform.environment['HOME'];
  if (home == null) return const [];
  final root = Directory('$home/Library/Developer/Xcode/DerivedData');
  if (!root.existsSync()) return const [];

  final iosDir = '${appRoot.resolveSymbolicLinksSync()}/ios';
  return root.listSync().whereType<Directory>().where((dir) {
    final info = File('${dir.path}/info.plist');
    if (!info.existsSync()) return false;
    final match = RegExp(r'<key>WorkspacePath</key>\s*<string>([^<]*)</string>')
        .firstMatch(info.readAsStringSync());
    final workspace = match?.group(1);
    return workspace != null && workspace.startsWith(iosDir);
  }).toList();
}

Never _fail(String message) {
  stderr.writeln('permission_handler_apple:select: $message');
  exit(1);
}

const _usage = '''
Usage: dart run permission_handler_apple:select <flavor>

  --list                  Show the flavors declared in $_configName.
  --app=<path>            App directory (defaults to the current directory).
  --derived-data=<path>   Custom DerivedData location, matching xcodebuild's
                          -derivedDataPath.
''';

const _exampleConfig = '''
{
  "strict": true,
  "flavors": {
    "dev":  { "infoPlist": "ios/Runner/Info-dev.plist",
              "configurations": ["Debug-dev", "Release-dev"] },
    "prod": { "infoPlist": "ios/Runner/Info-prod.plist",
              "configurations": ["Debug-prod", "Release-prod"] }
  }
}
''';
