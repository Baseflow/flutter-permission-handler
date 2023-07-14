import 'dart:html' as html;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import './permission_handler_web_test.mocks.dart';
import './fake_permission_handler_web.dart';

@GenerateMocks([
  html.Window,
  html.Navigator,
  html.MediaDevices,
  html.MediaStream,
  html.DomException
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockWindow window = MockWindow();
  final MockNavigator navigator = MockNavigator();
  final MockMediaDevices mediaDevices = MockMediaDevices();
  final MockMediaStream mediaStream = MockMediaStream();
  final MockDomException domException = MockDomException();

  final FakeWebPermissionHandler fakePlugin =
      FakeWebPermissionHandler(mediaDevices);

  final List<Permission> testPermissions = [
    Permission.contacts,
    //Permission.notification,
    //Permission.microphone,
    Permission.camera,
  ];

  when(window.navigator).thenReturn(navigator);
  when(navigator.mediaDevices).thenReturn(mediaDevices);

  // camera stubs

  when(mediaStream.active).thenReturn(true);
  when(mediaStream.getVideoTracks()).thenReturn(List.empty());

  // microphone stubs
  when(mediaDevices.getUserMedia({'audio': true}))
      .thenAnswer((_) async => mediaStream);
  when(mediaStream.getAudioTracks()).thenReturn(List.empty());

  test('request permission works for camera if user grants permission',
      () async {
    when(mediaDevices.getUserMedia({'video': true}))
        .thenAnswer((_) async => mediaStream);

    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.camera], PermissionStatus.granted);
  });

  test('request permission works for camera if user does not grant permission',
      () async {
    when(mediaDevices.getUserMedia({'video': true}))
        .thenThrow(domException);

    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.camera], PermissionStatus.permanentlyDenied);
  });
}
