# permission_handler_platform_interface

[![pub package](https://img.shields.io/pub/v/permission_handler_platform_interface.svg)](https://pub.dartlang.org/packages/permission_handler_platform_interface) ![Build status](https://github.com/Baseflow/flutter-permission-handler/workflows/permission_handler_platform_interface/badge.svg?branch=master) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)[![codecov](https://codecov.io/gh/Baseflow/flutter-permission-handler/branch/master/graph/badge.svg)](https://codecov.io/gh/Baseflow/flutter-permission-handler)

A common platform interface for the [`permission_handler`][1] plugin.

This interface allows platform-specific implementations of the
`permission_handler` plugin, as well as the plugin itself, to ensure they are
supporting the same interface.

# Usage

To implement a new platform-specific implementation of `permission_handler`,
extend [`PermissionHandlerPlatform`][2] with an implementation that performs
the platform-specific behavior, and when you register your plugin, set the
default `PermissionHandlerPlatform` by calling
`PermissionHandlerPlatform.instance = MyPlatformPermissionHandler()`.

# Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-permission-handler/issues) page.

# Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-permission-handler/pulls).

## Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less clean interface is preferable to a breaking change.

# Author

This Permission handler plugin for Flutter is developed by [Baseflow](https://baseflow.com). You can contact us at <hello@baseflow.com>

[1]: ../permission_handler
[2]: lib/permission_handler_platform_interface.dart
