import 'package:flutter/material.dart';
import 'package:permission_handler/permission_enums.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new ListView(
            children: PermissionGroup.values
              .where((PermissionGroup permission) => permission != PermissionGroup.unknown)
              .map((PermissionGroup permission) => new PermissionWidget(permission)).toList()
        ),
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
  final PermissionGroup _permissionGroup;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  _PermissionState(this._permissionGroup);
  
  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    print(_permissionGroup.toString());
    _permissionStatus = await PermissionHandler.checkPermissionStatus(_permissionGroup);
  }

    @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(_permissionGroup.toString()),
      subtitle: new Text(_permissionStatus.toString()),
    );
  }
}