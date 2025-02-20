import 'dart:io';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
  const PermissionHandlerWidget._();

  /// Create a page containing the functionality of this plugin
  static ExamplePage createPage() {
    return ExamplePage(
      Icons.location_on,
      (context) => const PermissionHandlerWidget._(),
    );
  }

  @override
  _PermissionHandlerWidgetState createState() =>
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
                  if (Platform.isIOS) {
                    return permission != Permission.unknown &&
                        permission != Permission.phone &&
                        permission != Permission.sms &&
                        permission != Permission.ignoreBatteryOptimizations &&
                        permission != Permission.accessMediaLocation &&
                        permission != Permission.activityRecognition &&
                        permission != Permission.manageExternalStorage &&
                        permission != Permission.systemAlertWindow &&
                        permission != Permission.requestInstallPackages &&
                        permission != Permission.accessNotificationPolicy &&
                        permission != Permission.bluetoothScan &&
                        permission != Permission.bluetoothAdvertise &&
                        permission != Permission.bluetoothConnect &&
                        permission != Permission.nearbyWifiDevices &&
                        permission != Permission.videos &&
                        permission != Permission.audio &&
                        permission != Permission.scheduleExactAlarm &&
                        permission != Permission.sensorsAlways;
                  } else {
                    return permission != Permission.unknown &&
                        permission != Permission.mediaLibrary &&
                        permission != Permission.photosAddOnly &&
                        permission != Permission.reminders &&
                        permission != Permission.bluetooth &&
                        permission != Permission.appTrackingTransparency &&
                        permission != Permission.criticalAlerts &&
                        permission != Permission.assistant;
                  }
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
  const PermissionWidget(this.permission, {super.key});

  /// The [Permission] for which this widget is rendered.
  final Permission permission;

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState();

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await widget.permission.status;
    setState(() => _permissionStatus = status);
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
    return ListTile(
      title: Text(
        widget.permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing:
          (widget.permission is PermissionWithService)
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

  void checkServiceStatus(
    BuildContext context,
    PermissionWithService permission,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((await permission.serviceStatus).toString())),
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }
}
