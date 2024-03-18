#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'permission_handler_apple'
  s.version          = '9.3.0'
  s.summary          = 'Permission plugin for Flutter.'
  s.description      = <<-DESC
Permission plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions.
                       DESC
  s.homepage         = 'https://github.com/baseflowit/flutter-permission-handler'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
  s.static_framework = true
  s.resource_bundles = {'permission_handler_apple_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end

