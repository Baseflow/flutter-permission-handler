// ignore_for_file: overridden_fields

import 'dart:html' as html;

import 'package:permission_handler_web/web_handler.dart';

class WebPermissionHandler extends WebHandler {
  @override
  html.MediaDevices? devices = html.window.navigator.mediaDevices!;
  @override
  html.Permissions? permissions = html.window.navigator.permissions;
}
