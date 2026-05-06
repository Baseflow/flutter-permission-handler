# permission_handler_android

[![pub package](https://img.shields.io/pub/v/permission_handler_android.svg)](https://pub.dartlang.org/packages/permission_handler_android) ![Build status](https://github.com/Baseflow/flutter-permission-handler/workflows/permission_handler_android/badge.svg?branch=master) [![style: flutter lints](https://img.shields.io/badge/style-flutter_lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)

The official Android implementation of the [permission_handler](https://pub.dev/packages/permission_handler) plugin by [Baseflow](https://baseflow.com).

## Usage

Since version 9.1.0 of the [permission_handler](https://pub.dev/packages/permission_handler) plugin this is the endorsed Android implementation. This means it will automatically be added to your dependencies when you depend on `permission_handler: ^9.1.0` in your applications pubspec.yaml.

More detailed instructions on using the API can be found in the [README.md](../permission_handler/README.md) of the [permission_handler](https://pub.dev/packages/permission_handler) package.

## Android build requirements

Starting with recent AndroidX versions used by this plugin, builds that depend on `permission_handler_android` may require a newer Android toolchain:

- compileSdkVersion: at least 36 (some AndroidX artifacts require API 36+)
- Android Gradle Plugin (AGP): 8.9.1 or newer
- Gradle distribution: use a compatible Gradle (for example Gradle 8.11.1+)

If you run into `Java heap space` errors while transforming dependencies during build, increase the Gradle JVM heap size in `android/gradle.properties`:

```properties
org.gradle.jvmargs=-Xmx4G
android.useAndroidX=true
android.enableJetifier=true
```

These changes were applied to the example projects in this repository to resolve CI build warnings and to ensure compatibility with newer AndroidX libraries.

## Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Baseflow/flutter-permission-handler/issues) page. Commercial support is available, you can contact us at <hello@baseflow.com>.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Baseflow/flutter-permission-handler/pulls).

## Author

This permission_handler plugin for Flutter is developed by [Baseflow](https://baseflow.com).
