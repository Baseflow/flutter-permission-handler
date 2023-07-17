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
  html.DomException,
  html.Permissions,
  html.PermissionStatus
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockWindow window = MockWindow();
  final MockNavigator navigator = MockNavigator();
  final MockMediaDevices mediaDevices = MockMediaDevices();
  final MockMediaStream mediaStream = MockMediaStream();
  final MockDomException domException = MockDomException();
  final MockPermissions permissions = MockPermissions();
  final MockPermissionStatus permissionStatus = MockPermissionStatus();

  final FakeWebPermissionHandler fakePlugin =
      FakeWebPermissionHandler(mediaDevices, permissions);

  final List<Permission> testPermissions = [
    Permission.contacts,
    Permission.notification,
    Permission.microphone,
    Permission.camera,
  ];

  when(window.navigator).thenReturn(navigator);
  when(navigator.mediaDevices).thenReturn(mediaDevices);
  when(permissions.query(any)).thenAnswer((_) async => permissionStatus);

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

    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(preActualStatus, PermissionStatus.denied);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.camera], PermissionStatus.granted);

    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(postActualStatus, PermissionStatus.granted);
  });

  test('request permission works for camera if user does not grant permission',
      () async {
    // stubs
    when(mediaDevices.getUserMedia({'video': true})).thenThrow(domException);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(
        permissionMap[Permission.camera], PermissionStatus.permanentlyDenied);

    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });
  test('request permission works for microphone if user grants permission',
      () async {
    when(mediaDevices.getUserMedia({'audio': true}))
        .thenAnswer((_) async => mediaStream);

    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(preActualStatus, PermissionStatus.denied);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.microphone], PermissionStatus.granted);

    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(postActualStatus, PermissionStatus.granted);
  });
  test('request permission works for camera if user does not grant permission',
      () async {
    // stubs
    when(mediaDevices.getUserMedia({'audio': true})).thenThrow(domException);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.microphone],
        PermissionStatus.permanentlyDenied);

    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });
}
