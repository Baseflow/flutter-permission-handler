# Flutter permission_handler plugin

The Flutter permission_handler plugin is build following the federated plugin architecture. A detailed explanation of the federated plugin concept can be found in the [Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins). This means the permission_handler plugin is separated into the following packages:

1. [`permission_handler`][1]: the app facing package. This is the package users depend on to use the plugin in their project. For details on how to use the `permission_handler` plugin you can refer to its [README.md][2] file. At this moment the Android and iOS platform implementations are also part of this package. Additional platform support will be added in their own individual "platform package(s)".
2. [`permission_handler_platform_interface`][3]: this packages declares the interface which all platform packages must implement to support the app-facing package. Instructions on how to implement a platform packages can be found in the [README.md][4] of the `permission_handler_platform_interface` package.

[1]: https://pub.dev/packages/permission_handler
[2]: ./permission_handler/README.md
[3]: https://pub.dev/packages/permission_handler_platform_interface
[4]: ./permission_handler_platform_interface/README.md
