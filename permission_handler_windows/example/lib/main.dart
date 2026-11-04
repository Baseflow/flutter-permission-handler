// ignore_for_file: avoid_print

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
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
  /// Creates a [PermissionHandlerWidget] that listens for permission status changes.
  const PermissionHandlerWidget({super.key});

  /// Create a page containing the functionality of this plugin
  static ExamplePage createPage() {
    return ExamplePage(
      Icons.location_on,
      (context) => PermissionHandlerWidget(),
    );
  }

  @override
  PermissionHandlerWidgetState createState() => PermissionHandlerWidgetState();
}

/// State for the [PermissionHandlerWidget] that listens for permission status changes.
class PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: Permission.values
            .where((permission) {
              return permission != Permission.unknown &&
                  permission != Permission.mediaLibrary &&
                  permission != Permission.photos &&
                  permission != Permission.photosAddOnly &&
                  permission != Permission.reminders &&
                  permission != Permission.appTrackingTransparency &&
                  permission != Permission.criticalAlerts;
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

  /// Returns the [Permission] associated with this widget.
  Permission get permission => _permission;

  @override
  PermissionWidgetState createState() => PermissionWidgetState();
}

/// State for the [PermissionWidget] that listens for permission status changes.
class PermissionWidgetState extends State<PermissionWidget> {
  /// Constructs a [PermissionWidgetState] for the supplied [PermissionWidget].
  PermissionWidgetState();
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status =
        await _permissionHandler.checkPermissionStatus(widget.permission);
    setState(() => _permissionStatus = status);
  }

  /// Returns the color to use for the permission status.
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
    return ListTile(
      title: Text(
        widget.permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: (widget.permission is PermissionWithService)
          ? IconButton(
              icon: const Icon(Icons.info, color: Colors.white),
              onPressed: () {
                checkServiceStatus(
                  context,
                  widget.permission as PermissionWithService,
                );
              },
            )
          : null,
      onTap: () {
        requestPermission(widget.permission);
      },
    );
  }

  /// Requests permission for the given [Permission].
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

  /// Requests permission for the given [Permission].
  Future<void> requestPermission(Permission permission) async {
    final status = await _permissionHandler.requestPermissions([permission]);

    setState(() {
      print(status);
      _permissionStatus = status[permission] ?? PermissionStatus.denied;
      print(_permissionStatus);
    });
  }
}
