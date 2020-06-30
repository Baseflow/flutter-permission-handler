import 'dart:core';
import 'package:flutter/material.dart';
import 'package:permission_handler_example/plugin_example/permission_list.dart';

import 'info_page.dart';

/// Globals for example app template
class Globals {
  /// Plugin Name
  static const String pluginName = 'CachedNetworkImage';

  /// Github URL to plugin
  static const String githubURL =
      'https://github.com/Baseflow/flutter_cached_network_image/';

  /// Baseflow URL
  static const String baseflowURL = 'https://baseflow.com';

  /// Pub.dev link to plugin
  static const String pubDevURL =
      'https://pub.dev/packages/cached_network_image';

  /// Application wide default horizontal padding
  static const EdgeInsets defaultHorizontalPadding =
      EdgeInsets.symmetric(horizontal: 24);

  /// Application wide default horizontal padding
  static const EdgeInsets defaultVerticalPadding =
      EdgeInsets.symmetric(vertical: 24);

  /// List of icons for BottomAppBar
  static final icons = [
    Icons.list,
    Icons.info_outline,
  ];

  /// List of pages in BottomAppBar
  static final pages = [
    PermissionList(),
    InfoPage(),
  ];
}
