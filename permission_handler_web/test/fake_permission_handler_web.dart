// ignore_for_file: overridden_fields

import 'dart:html' as html;

import 'package:permission_handler_web/web_handler.dart';

class FakeWebPermissionHandler extends WebHandler {
  FakeWebPermissionHandler(this.devices, this.permissions);
  @override
  html.MediaDevices? devices;
  @override
  html.Permissions? permissions;
}
