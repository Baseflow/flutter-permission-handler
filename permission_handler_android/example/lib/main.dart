// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

void main() {
  runApp(const PermissionHandlerExampleApp());
}

class PermissionHandlerExampleApp extends StatelessWidget {
  const PermissionHandlerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permission Handler Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PermissionHandlerWidget(),
    );
  }
}

class PermissionHandlerWidget extends StatefulWidget {
  const PermissionHandlerWidget({super.key});

  @override
  State<PermissionHandlerWidget> createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Handler')),
      body: Center(
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
      ),
    );
  }
}

class PermissionWidget extends StatefulWidget {
  const PermissionWidget(this._permission, {super.key});

  final Permission _permission;

  @override
  State<PermissionWidget> createState() => _PermissionState();
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState();

  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permissionHandler.checkPermissionStatus(
      widget._permission,
    );
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
        widget._permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing:
          (widget._permission is PermissionWithService)
              ? IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  checkServiceStatus(
                    context,
                    widget._permission as PermissionWithService,
                  );
                },
              )
              : null,
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

    setState(() {
      _permissionStatus = status[permission] ?? PermissionStatus.denied;
    });
  }
}
