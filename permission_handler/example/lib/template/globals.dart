import 'dart:core';

import 'package:flutter/material.dart';
import '../plugin_example/permission_list.dart';

import 'info_page.dart';

/// Constant plugin name
const String pluginName = 'Geocoding';

/// Constant GitHub URL to flutter package
const String githubURL = 'https://github.com/Baseflow/flutter-geocoding';

/// Constant Baseflow URL
const String baseflowURL = 'https://baseflow.com';

/// Constant pub.dev URL to flutter package
const String pubDevURL = 'https://pub.dev/packages/geocoding';

/// Constant application-wide horizontal padding
const EdgeInsets defaultHorizontalPadding =
    EdgeInsets.symmetric(horizontal: 24);

/// Constant application-wide vertical padding
const EdgeInsets defaultVerticalPadding = EdgeInsets.symmetric(vertical: 24);

/// Constant list of AppBar Icons
final List<IconData> icons = [
  Icons.list,
  Icons.info_outline,
];

/// Constant list of application widgets
final List<Widget> pages = [
  PermissionList(),
  InfoPage(),
];
