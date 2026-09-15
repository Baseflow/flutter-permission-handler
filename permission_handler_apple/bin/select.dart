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
//
// The configuration lives in permission_handler.yaml, but a Swift package
// manifest cannot parse YAML — Foundation has no YAML support and a manifest
// cannot import libraries for its own evaluation. This command is therefore the
// only YAML reader: it translates the config into a generated
// permission_handler.resolved.json that the manifest and the verification build
// phase consume with their native JSON parsers. The generated file is an
// internal artifact — gitignore it, never edit it.

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const _configName = 'permission_handler.yaml';
const _selectionPath = 'ios/Flutter/permission_handler.selected';
const _resolvedPath = 'ios/Flutter/permission_handler.resolved.json';

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

  final config = _readConfig(configFile);

  if (flags.containsKey('list')) {
    stdout.writeln('Flavors declared in ${configFile.path}:');
    for (final entry in config.flavors.entries) {
      final exists =
          File('${appRoot.path}/${entry.value.infoPlist}').existsSync();
      stdout.writeln('  ${entry.key.padRight(12)} ${entry.value.infoPlist}'
          '${exists ? '' : '   (missing!)'}');
    }
    return;
  }

  if (positional.length != 1) {
    _fail('Expected exactly one flavor name.\n\n$_usage');
  }
  final flavor = positional.single;

  final entry = config.flavors[flavor];
  if (entry == null) {
    _fail('Flavor "$flavor" is not declared in ${configFile.path}.\n'
        'Known flavors: ${config.flavors.keys.join(', ')}');
  }

  final plist = File('${appRoot.path}/${entry.infoPlist}');
  if (!plist.existsSync()) {
    _fail(
        'Flavor "$flavor" points at ${entry.infoPlist}, which does not exist.');
  }

  _writeResolved(appRoot, config);

  final selection = File('${appRoot.path}/$_selectionPath');
  selection.parent.createSync(recursive: true);
  selection.writeAsStringSync('$flavor\n');

  final cleared = _clearCaches(appRoot, flags['derived-data']);

  stdout.writeln('Selected flavor "$flavor" (${entry.infoPlist}).');
  stdout.writeln('');
  stdout.writeln('Permissions that will be compiled in:');
  final descriptions = _usageDescriptions(plist);
  if (descriptions.isEmpty) {
    stdout.writeln(
        '  (none — ${entry.infoPlist} declares no usage descriptions)');
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

class _Flavor {
  const _Flavor(this.infoPlist, this.configurations);

  final String infoPlist;
  final List<String> configurations;
}

class _Config {
  const _Config(this.strict, this.flavors);

  final bool strict;
  final Map<String, _Flavor> flavors;
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

_Config _readConfig(File configFile) {
  final Object? decoded;
  try {
    decoded = loadYaml(configFile.readAsStringSync());
  } on YamlException catch (e) {
    _fail('${configFile.path} is not valid YAML: ${e.message}');
  }

  if (decoded is! YamlMap) {
    _fail('${configFile.path} must contain a YAML mapping.\n\n$_exampleConfig');
  }
  final flavors = decoded['flavors'];
  if (flavors is! YamlMap || flavors.isEmpty) {
    _fail('${configFile.path} declares no "flavors".\n\n$_exampleConfig');
  }

  // This command is the only thing that reads the YAML, so it is the only place
  // that can reject a malformed config. Everything downstream sees the
  // generated JSON and has no way to tell a deliberate value from a typo, so
  // validation that is skipped here is validation that never happens.
  final result = <String, _Flavor>{};
  final claimedBy = <String, String>{}; // build configuration -> flavor

  for (final entry in flavors.entries) {
    final key = entry.key;
    if (key is! String) {
      _fail('Flavor name ${jsonEncode(key)} in ${configFile.path} is not a '
          'string. Quote it if you meant a literal name: "$key".');
    }
    final name = key;

    final value = entry.value;
    if (value is! YamlMap || value['info-plist'] is! String) {
      _fail('Flavor "$name" in ${configFile.path} has no "info-plist" string.');
    }

    // A scalar here used to become an empty list, which silently disables the
    // build phase's mismatch check for every configuration of this flavor.
    final configurations = value['configurations'];
    if (configurations != null && configurations is! YamlList) {
      _fail('Flavor "$name" in ${configFile.path} has a "configurations" that '
          'is not a list. Write it as:\n'
          '    configurations:\n'
          '      - Debug-$name\n'
          '      - Release-$name');
    }

    final names =
        (configurations as YamlList?)?.map((c) => c.toString()).toList() ??
            const <String>[];

    // Two flavors claiming one configuration makes the build phase pick
    // whichever comes first and demand that flavor, which would talk the user
    // into shipping the other flavor's permissions.
    for (final configuration in names) {
      final owner = claimedBy[configuration];
      if (owner != null) {
        _fail('Build configuration "$configuration" in ${configFile.path} is '
            'claimed by both "$owner" and "$name". Each configuration must '
            'belong to exactly one flavor, otherwise the build cannot tell '
            'which permissions it should ship.');
      }
      claimedBy[configuration] = name;
    }

    result[name] = _Flavor(value['info-plist'] as String, names);
  }

  final strict = decoded['strict'];
  if (strict != null && strict is! bool) {
    _fail('"strict" in ${configFile.path} must be true or false, not '
        '${jsonEncode(strict.toString())}.');
  }

  return _Config(strict as bool? ?? true, result);
}

/// Write the generated JSON translation the manifest and build phase read.
///
/// The camelCase `infoPlist` key is deliberate: it matches what Package.swift
/// and verify_flavor_selection.sh already parse, and this file is not
/// user-facing.
void _writeResolved(Directory appRoot, _Config config) {
  final resolved = File('${appRoot.path}/$_resolvedPath');
  resolved.parent.createSync(recursive: true);
  resolved.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'note': 'Generated by permission_handler_apple:select from '
          '$_configName. Do not edit or commit.',
      'strict': config.strict,
      'flavors': {
        for (final entry in config.flavors.entries)
          entry.key: {
            'infoPlist': entry.value.infoPlist,
            'configurations': entry.value.configurations,
          },
      },
    }),
  );
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
strict: true
flavors:
  dev:
    info-plist: ios/Runner/Info-dev.plist
    configurations:
      - Debug-dev
      - Release-dev
  prod:
    info-plist: ios/Runner/Info-prod.plist
    configurations:
      - Debug-prod
      - Release-prod
''';
