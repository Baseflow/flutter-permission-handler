import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  runApp(
    BaseflowPluginExample(
      pluginName: 'Permission Handler',
      githubURL: 'https://github.com/Baseflow/flutter-permission-handler',
      pubDevURL: 'https://pub.dev/packages/permission_handler',
      pages: [PermissionHandlerWidget.createPage()],
    ),
  );
}

///Defines the main theme color
final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
      const Color.fromRGBO(48, 49, 60, 1),
    );

/// A Flutter application demonstrating the functionality of this plugin
class PermissionHandlerWidget extends StatefulWidget {
  /// Creates a [PermissionHandlerWidget].
  const PermissionHandlerWidget({super.key});

  /// Create a page containing the functionality of this plugin
  static ExamplePage createPage() {
    return ExamplePage(
      Icons.location_on,
      (context) => const PermissionHandlerWidget(),
    );
  }

  @override
  State<PermissionHandlerWidget> createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children:
            Permission.values
                .where((permission) {
                  return permission != Permission.unknown &&
                      permission != Permission.mediaLibrary &&
                      permission != Permission.photosAddOnly &&
                      permission != Permission.reminders &&
                      permission != Permission.bluetooth &&
                      permission != Permission.appTrackingTransparency &&
                      permission != Permission.criticalAlerts &&
                      permission != Permission.assistant &&
                      permission != Permission.backgroundRefresh;
                })
                .map((permission) => PermissionWidget(permission))
                .toList(),
      ),
    );
  }
}

/// Permission widget containing information about the passed [Permission]
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission]
  const PermissionWidget(this._permission, {super.key});

  final Permission _permission;

  @override
  State<PermissionWidget> createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState();

  static const MethodChannel _granularityChannel = MethodChannel(
    'location_granularity',
  );
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool? _isFineGranted;
  bool? _isCoarseGranted;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permissionHandler.checkPermissionStatus(
      widget._permission,
    );
    if (!mounted) return;
    setState(() => _permissionStatus = status);
    await _updateGranularity();
  }

  Future<void> _updateGranularity() async {
    if (widget._permission != Permission.location) {
      if (_isFineGranted != null || _isCoarseGranted != null) {
        setState(() {
          _isFineGranted = null;
          _isCoarseGranted = null;
        });
      }
      return;
    }

    try {
      final result = await _granularityChannel.invokeMapMethod<String, bool>(
        'status',
      );
      if (!mounted) return;
      setState(() {
        _isFineGranted = result?['fine'];
        _isCoarseGranted = result?['coarse'];
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isFineGranted = null;
        _isCoarseGranted = null;
      });
    }
  }

  String granularityLabel() {
    if (widget._permission != Permission.location) return '';
    if (_isFineGranted == true) return 'Precise';
    if (_isCoarseGranted == true) return 'Approximate';
    return '';
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final extraGranularity = granularityLabel();
    final subtitleText =
        extraGranularity.isNotEmpty
            ? '${_permissionStatus.toString()} · $extraGranularity'
            : _permissionStatus.toString();

    final trailingActions = <Widget>[];
    if (widget._permission is PermissionWithService) {
      trailingActions.add(
        IconButton(
          icon: const Icon(Icons.info, color: Colors.white),
          onPressed: () {
            checkServiceStatus(
              context,
              widget._permission as PermissionWithService,
            );
          },
        ),
      );
    }

    final isApproximateOnly =
        widget._permission == Permission.location &&
        _isFineGranted != true &&
        _isCoarseGranted == true;
    if (isApproximateOnly) {
      trailingActions.add(
        IconButton(
          icon: const Icon(Icons.my_location, color: Colors.white),
          tooltip: 'Request precise',
          onPressed: () => requestPermission(widget._permission),
        ),
      );
    }

    return ListTile(
      title: Text(
        widget._permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        subtitleText,
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing:
          trailingActions.isEmpty
              ? null
              : Row(mainAxisSize: MainAxisSize.min, children: trailingActions),
      onTap: () {
        requestPermission(widget._permission);
      },
    );
  }

  void checkServiceStatus(
    BuildContext context,
    PermissionWithService permission,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (await _permissionHandler.checkServiceStatus(permission)).toString(),
        ),
      ),
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await _permissionHandler.requestPermissions([permission]);

    if (!mounted) return;
    setState(() {
      _permissionStatus = status[permission] ?? PermissionStatus.denied;
    });
    await _updateGranularity();
  }
}
