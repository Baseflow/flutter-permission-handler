#include "include/permission_handler_windows/permission_handler_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_channel.h>
#include <flutter/event_stream_handler.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/encodable_value.h>
#include <windows.h>

#include <memory>
#include <optional>
#include <sstream>
#include <map>
#include <string>
#include <variant>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Devices.Geolocation.h>
#include <winrt/Windows.Devices.Bluetooth.h>
#include <winrt/Windows.Devices.Radios.h>
#include <winrt/Windows.Foundation.Collections.h>

#include "permission_constants.h"

namespace {

using namespace flutter;
using namespace winrt;
using namespace winrt::Windows::Devices::Geolocation;
using namespace winrt::Windows::Devices::Bluetooth;
using namespace winrt::Windows::Devices::Radios;

template<typename T>
T GetArgument(const std::string arg, const flutter::EncodableValue* args, T fallback) {
  T result {fallback};
  const auto* arguments = std::get_if<flutter::EncodableMap>(args);
  if (arguments) {
    auto result_it = arguments->find(flutter::EncodableValue(arg));
    if (result_it != arguments->end()) {
      result = std::get<T>(result_it->second);
    }
  }
  return result;
}

class PermissionHandlerWindowsPlugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar);

  PermissionHandlerWindowsPlugin();

  virtual ~PermissionHandlerWindowsPlugin();

  // Disallow copy and move.
  PermissionHandlerWindowsPlugin(const PermissionHandlerWindowsPlugin&) = delete;
  PermissionHandlerWindowsPlugin& operator=(const PermissionHandlerWindowsPlugin&) = delete;

  // Called when a method is called on the plugin channel.
  void HandleMethodCall(const flutter::MethodCall<>&,
                        std::unique_ptr<flutter::MethodResult<>>);

 private:
  void IsLocationServiceEnabled(std::unique_ptr<flutter::MethodResult<>> result);
  winrt::fire_and_forget IsBluetoothServiceEnabled(std::unique_ptr<flutter::MethodResult<>> result);

  winrt::Windows::Devices::Geolocation::Geolocator geolocator;
  winrt::Windows::Devices::Geolocation::Geolocator::PositionChanged_revoker m_positionChangedRevoker;
};

// static
void PermissionHandlerWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrar* registrar) {

  auto channel = std::make_unique<flutter::MethodChannel<>>(
    registrar->messenger(), "flutter.baseflow.com/permissions/methods",
    &flutter::StandardMethodCodec::GetInstance());

  std::unique_ptr<PermissionHandlerWindowsPlugin> plugin = std::make_unique<PermissionHandlerWindowsPlugin>();

  channel->SetMethodCallHandler(
    [plugin_pointer = plugin.get()](const auto& call, auto result) {
      plugin_pointer->HandleMethodCall(call, std::move(result));
    });

  // Plugin instance is managed by the channel
}

PermissionHandlerWindowsPlugin::PermissionHandlerWindowsPlugin(){
  m_positionChangedRevoker = geolocator.PositionChanged(winrt::auto_revoke,
    [this](Geolocator const& geolocator, PositionChangedEventArgs e)
    {
    });
}

PermissionHandlerWindowsPlugin::~PermissionHandlerWindowsPlugin() = default;

void PermissionHandlerWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<>& method_call,
    std::unique_ptr<flutter::MethodResult<>> result) {
  
  auto methodName = method_call.method_name();
  if (methodName.compare("checkServiceStatus") == 0) {
    auto permission = (PermissionConstants::PermissionGroup)std::get<int>(*method_call.arguments());
    if (permission == PermissionConstants::PermissionGroup::LOCATION ||
        permission == PermissionConstants::PermissionGroup::LOCATION_ALWAYS ||
        permission == PermissionConstants::PermissionGroup::LOCATION_WHEN_IN_USE) {
        IsLocationServiceEnabled(std::move(result));
        return;
    }
    if(permission == PermissionConstants::PermissionGroup::BLUETOOTH){
        IsBluetoothServiceEnabled(std::move(result));
        return;
    }

    if (permission == PermissionConstants::PermissionGroup::IGNORE_BATTERY_OPTIMIZATIONS) {
        result->Success(flutter::EncodableValue((int)PermissionConstants::ServiceStatus::ENABLED));
        return;
    }

    result->Success(flutter::EncodableValue((int)PermissionConstants::ServiceStatus::NOT_APPLICABLE));
    
  } else if (methodName.compare("checkPermissionStatus") == 0) {
    result->Success(flutter::EncodableValue((int)PermissionConstants::PermissionStatus::GRANTED));
  } else if (methodName.compare("requestPermissions") == 0) {
    auto permissionsEncoded = std::get<flutter::EncodableList>(*method_call.arguments());
    std::vector<int> permissions;
    permissions.reserve( permissionsEncoded.size() );
    std::transform( permissionsEncoded.begin(), permissionsEncoded.end(),
                    std::back_inserter( permissions ),
                    [](const flutter::EncodableValue& encoded) {
                      return std::get<int>(encoded);
                    });
    
    flutter::EncodableMap requestResults;

    for (int i=0;i<permissions.size();i++) {
      auto permissionStatus = PermissionConstants::PermissionStatus::GRANTED;
      requestResults.insert({flutter::EncodableValue(permissions[i]), flutter::EncodableValue((int)permissionStatus)});
    }

    result->Success(requestResults);
  } else if (methodName.compare("shouldShowRequestPermissionRationale") == 0
          || methodName.compare("openAppSettings")) {
    result->Success(flutter::EncodableValue(false));
  } else {
    result->NotImplemented();
  }
}

void PermissionHandlerWindowsPlugin::IsLocationServiceEnabled(std::unique_ptr<flutter::MethodResult<>> result) {
  result->Success(flutter::EncodableValue((int)(geolocator.LocationStatus() != PositionStatus::NotAvailable
        ? PermissionConstants::ServiceStatus::ENABLED
        : PermissionConstants::ServiceStatus::DISABLED)));
}

winrt::fire_and_forget PermissionHandlerWindowsPlugin::IsBluetoothServiceEnabled(std::unique_ptr<flutter::MethodResult<>> result) {
  auto btAdapter = co_await BluetoothAdapter::GetDefaultAsync();

  if (btAdapter == nullptr) {
    result->Success(flutter::EncodableValue((int)PermissionConstants::ServiceStatus::DISABLED));
    co_return;
  }
  
  if (!btAdapter.IsCentralRoleSupported()) {
    result->Success(flutter::EncodableValue((int)PermissionConstants::ServiceStatus::DISABLED));
    co_return;
  }
  
  auto radios = co_await Radio::GetRadiosAsync();

  for (uint32_t i=0; i<radios.Size(); i++) {
    auto radio = radios.GetAt(i);
    if(radio.Kind() == RadioKind::Bluetooth) {
      co_await radio.SetStateAsync(RadioState::On);
      result->Success(flutter::EncodableValue((int)(radio.State() == RadioState::On
            ? PermissionConstants::ServiceStatus::ENABLED
            : PermissionConstants::ServiceStatus::DISABLED)));
      co_return;
    }
  }

  result->Success(flutter::EncodableValue((int)PermissionConstants::ServiceStatus::DISABLED));
}

}  // namespace

void PermissionHandlerWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  auto plugin_registrar = 
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar);
  PermissionHandlerWindowsPlugin::RegisterWithRegistrar(plugin_registrar);
}
