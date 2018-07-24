import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_enums.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _permissionStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    PermissionStatus permissionStatus;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      permissionStatus = await PermissionHandler
          .checkPermissionStatus(PermissionGroup.calendar);

      if (permissionStatus != PermissionStatus.granted) {
        final bool shouldShowRationale = await PermissionHandler
            .shouldShowRequestPermissionRationale(PermissionGroup.calendar);

        if (shouldShowRationale) {
          final Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler
              .requestPermissions(<PermissionGroup>[PermissionGroup.calendar]);
          if (permissions.containsKey(PermissionGroup.calendar)) {
            permissionStatus = permissions[PermissionGroup.calendar];
          }
        }
      }
    } on PlatformException {
      permissionStatus = PermissionStatus.unknown;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _permissionStatus = permissionStatus.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Text('Running on: $_permissionStatus\n'),
              new RaisedButton(
                child: const Text('Open settings'),
                onPressed: () async =>
                    await PermissionHandler.openAppSettings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
