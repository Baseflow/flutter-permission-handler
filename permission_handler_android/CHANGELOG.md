## 9.0.2+1

* Undoes PR [#765](https://github.com/baseflow/flutter-permission-handler/pull/765) which by mistake requests write_external_storage permission based on the target SDK instead of the actual SDK of the Android device.

## 9.0.2

* Moves Android implementation into its own package.