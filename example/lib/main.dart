import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              PermissionHandler().openAppSettings();
            },
          )
        ],
      ),
      body: new Center(
        child: new ListView(
            children: PermissionGroup.values
                .where((PermissionGroup permission) {
                  if (Platform.isIOS) {
                    return permission != PermissionGroup.unknown &&
                        permission != PermissionGroup.phone &&
                        permission != PermissionGroup.sms &&
                        permission != PermissionGroup.storage;
                  } else {
                    return permission != PermissionGroup.unknown &&
                        permission != PermissionGroup.mediaLibrary &&
                        permission != PermissionGroup.photos &&
                        permission != PermissionGroup.reminders;
                  }
                })
                .map((PermissionGroup permission) =>
                    new PermissionWidget(permission))
                .toList()),
      ),
    ));
  }
}

class PermissionWidget extends StatefulWidget {
  final PermissionGroup _permissionGroup;

  const PermissionWidget(this._permissionGroup);

  @override
  _PermissionState createState() => _PermissionState(_permissionGroup);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permissionGroup);

  final PermissionGroup _permissionGroup;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final PermissionStatus status =
        await PermissionHandler().checkPermissionStatus(_permissionGroup);

    setState(() {
      _permissionStatus = status;
    });
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(_permissionGroup.toString()),
      subtitle: new Text(
        _permissionStatus.toString(),
        style: new TextStyle(color: getPermissionColor()),
      ),
      onTap: () async {
        requestPermission(_permissionGroup);
      },
    );
  }

  void requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      _permissionStatus = permissionRequestResult[permission];
    });
  }
}
