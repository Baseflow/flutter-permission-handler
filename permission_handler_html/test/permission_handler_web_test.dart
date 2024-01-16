import 'dart:html' as html;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:permission_handler_html/web_delegate.dart';
import 'permission_handler_web_test.mocks.dart';

@GenerateMocks([
  html.DomException,
  html.Geolocation,
  html.Geoposition,
  html.MediaDevices,
  html.MediaStream,
  html.Navigator,
  html.Permissions,
  html.PermissionStatus,
  html.PositionError,
  html.Window,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockDomException domException = MockDomException();
  final MockGeolocation geolocation = MockGeolocation();
  final MockGeoposition geoposition = MockGeoposition();
  final MockMediaDevices mediaDevices = MockMediaDevices();
  final MockMediaStream mediaStream = MockMediaStream();
  final MockNavigator navigator = MockNavigator();
  final MockPermissions permissions = MockPermissions();
  final MockPermissionStatus permissionStatus = MockPermissionStatus();
  final MockPositionError positionError = MockPositionError();
  final MockWindow window = MockWindow();

  final WebDelegate fakePlugin =
      WebDelegate(mediaDevices, geolocation, permissions);

  final List<Permission> testPermissions = [
    Permission.camera,
    Permission.contacts,
    Permission.location,
    Permission.microphone,
    Permission.notification,
  ];

  when(window.navigator).thenReturn(navigator);
  when(navigator.mediaDevices).thenReturn(mediaDevices);
  when(navigator.geolocation).thenReturn(geolocation);
  when(permissions.query(any)).thenAnswer((_) async => permissionStatus);

  // camera stubs
  when(mediaStream.active).thenReturn(true);
  when(mediaStream.getVideoTracks()).thenReturn(List.empty());

  // microphone stubs
  when(mediaDevices.getUserMedia({'audio': true}))
      .thenAnswer((_) async => mediaStream);
  when(mediaStream.getAudioTracks()).thenReturn(List.empty());

  // location stubs
  when(geolocation.getCurrentPosition()).thenAnswer((_) async => geoposition);

  test(
      'check permission works for camera before user is prompted for permission',
      () async {
    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(preActualStatus, PermissionStatus.denied);
  });
  test('check permission works for camera after user accepts permission',
      () async {
    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(postActualStatus, PermissionStatus.granted);
  });
  test('check permission works for camera after user declines permission',
      () async {
    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.camera);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });

  test('request permission works for camera if user grants permission',
      () async {
    when(mediaDevices.getUserMedia({'video': true}))
        .thenAnswer((_) async => mediaStream);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.camera], PermissionStatus.granted);
  });

  test('request permission works for camera if user does not grant permission',
      () async {
    // stubs
    when(mediaDevices.getUserMedia({'video': true})).thenThrow(domException);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(
        permissionMap[Permission.camera], PermissionStatus.permanentlyDenied);
  });

  test(
      'check permission works for microphone before user is prompted for permission',
      () async {
    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(preActualStatus, PermissionStatus.denied);
  });
  test('check permission works for microphone after user accepts permission',
      () async {
    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(postActualStatus, PermissionStatus.granted);
  });
  test('check permission works for microphone after user declines permission',
      () async {
    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.microphone);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });

  test('request permission works for microphone if user grants permission',
      () async {
    when(mediaDevices.getUserMedia({'audio': true}))
        .thenAnswer((_) async => mediaStream);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.microphone], PermissionStatus.granted);
  });
  test(
      'request permission works for microphone if user does not grant permission',
      () async {
    // stubs
    when(mediaDevices.getUserMedia({'audio': true})).thenThrow(domException);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.microphone],
        PermissionStatus.permanentlyDenied);
  });

  test(
      'check permission works for notification before user is prompted for permission',
      () async {
    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.notification);

    expect(preActualStatus, PermissionStatus.denied);
  });
  test('check permission works for notification after user accepts permission',
      () async {
    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.notification);

    expect(postActualStatus, PermissionStatus.granted);
  });
  test('check permission works for notification after user declines permission',
      () async {
    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.notification);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });

  test(
      'check permission works for location before user is prompted for permission',
      () async {
    when(permissionStatus.state).thenReturn('prompt');

    // check permissions status before requesting
    final preActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.location);

    expect(preActualStatus, PermissionStatus.denied);
  });
  test('check permission works for location after user accepts permission',
      () async {
    when(permissionStatus.state).thenReturn('granted');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.location);

    expect(postActualStatus, PermissionStatus.granted);
  });
  test('check permission works for location after user declines permission',
      () async {
    when(permissionStatus.state).thenReturn('denied');

    // check permissions status after requesting
    final postActualStatus =
        await fakePlugin.checkPermissionStatus(Permission.location);

    expect(postActualStatus, PermissionStatus.permanentlyDenied);
  });

  test('request permission works for location if user grants permission',
      () async {
    when(geolocation.getCurrentPosition()).thenAnswer((_) async => geoposition);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(permissionMap[Permission.location], PermissionStatus.granted);
  });
  test(
      'request permission works for location if user does not grant permission',
      () async {
    // stubs
    when(geolocation.getCurrentPosition()).thenThrow(positionError);

    // request permission
    final permissionMap = await fakePlugin.requestPermissions(testPermissions);

    expect(
        permissionMap[Permission.location], PermissionStatus.permanentlyDenied);
  });
}
