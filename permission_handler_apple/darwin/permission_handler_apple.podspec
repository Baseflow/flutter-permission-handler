# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name             = 'permission_handler_apple'
  s.version          = '9.5.0'
  s.summary          = 'Permission plugin for Flutter.'
  s.description      = <<-DESC
Permission plugin for Flutter. This plugin provides a cross-platform API to request and check permissions.
                       DESC
  s.homepage         = 'https://github.com/baseflow/flutter-permission-handler'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :path => '.' }
  s.source_files = 'permission_handler_apple/Sources/permission_handler_apple/**/*.swift'
  s.dependency 'Flutter'

  s.ios.deployment_target = '14.0'
  s.static_framework = true
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) PERMISSION_EVENTS=1 PERMISSION_EVENTS_FULL_ACCESS=1 PERMISSION_REMINDERS=1 PERMISSION_CONTACTS=1 PERMISSION_CAMERA=1 PERMISSION_MICROPHONE=1 PERMISSION_SPEECH_RECOGNIZER=1 PERMISSION_PHOTOS=1 PERMISSION_PHOTOS_ADD_ONLY=1 PERMISSION_LOCATION=1 PERMISSION_LOCATION_WHENINUSE=1 PERMISSION_LOCATION_ALWAYS=1 PERMISSION_NOTIFICATIONS=1 PERMISSION_MEDIA_LIBRARY=1 PERMISSION_SENSORS=1 PERMISSION_BLUETOOTH=1 PERMISSION_APP_TRACKING_TRANSPARENCY=1 PERMISSION_CRITICAL_ALERTS=1 PERMISSION_ASSISTANT=1',
  }
  s.swift_version = '5.0'
  s.resource_bundles = {
    'permission_handler_apple_privacy' => [
      'permission_handler_apple/Sources/permission_handler_apple/PrivacyInfo.xcprivacy',
    ],
  }
end
