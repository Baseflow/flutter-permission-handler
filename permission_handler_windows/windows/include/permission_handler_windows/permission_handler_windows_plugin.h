#ifndef PACKAGES_PERMISSION_HANDLER_PERMISSION_HANDLER_WINDOWS_WINDOWS_INCLUDE_PERMISSION_HANDLER_WINDOWS_PERMISSION_HANDLER_PLUGIN_H_
#define PACKAGES_PERMISSION_HANDLER_PERMISSION_HANDLER_WINDOWS_WINDOWS_INCLUDE_PERMISSION_HANDLER_WINDOWS_PERMISSION_HANDLER_PLUGIN_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void PermissionHandlerWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // PACKAGES_PERMISSION_HANDLER_PERMISSION_HANDLER_WINDOWS_WINDOWS_INCLUDE_PERMISSION_HANDLER_WINDOWS_PERMISSION_HANDLER_PLUGIN_H_
