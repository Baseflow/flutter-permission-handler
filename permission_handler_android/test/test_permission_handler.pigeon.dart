// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:permission_handler_android/src/permission_handler.pigeon.dart';

class _ActivityTestHostApiCodec extends StandardMessageCodec {
  const _ActivityTestHostApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ActivityResultPigeon) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is PermissionRequestResult) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return ActivityResultPigeon.decode(readValue(buffer)!);
      case 129:
        return PermissionRequestResult.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// Host API for `Activity`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/app/Activity.
abstract class ActivityTestHostApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = _ActivityTestHostApiCodec();

  /// Gets whether the application should show UI with rationale before requesting a permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#shouldShowRequestPermissionRationale(java.lang.String).
  bool shouldShowRequestPermissionRationale(
      String instanceId, String permission);

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/app/Activity#checkSelfPermission(java.lang.String).
  int checkSelfPermission(String instanceId, String permission);

  /// Requests permissions to be granted to this application.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// permission results are returned as a [Future] instead of through a
  /// separate callback.
  ///
  /// See
  /// https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String[],%20int)
  /// and
  /// https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[]).
  Future<PermissionRequestResult> requestPermissions(
      String instanceId, List<String?> permissions);

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  void startActivity(String instanceId, String intentInstanceId);

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  String getPackageName(String instanceId);

  /// Start an activity for which the application would like a result when it finished.
  ///
  /// Contrary to the Android SDK, we do not make use of a `requestCode`, as
  /// activity results are returned as a [Future].
  ///
  /// See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
  Future<ActivityResultPigeon> startActivityForResult(
      String instanceId, String intentInstanceId);

  static void setup(ActivityTestHostApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale was null, expected non-null String.');
          final String? arg_permission = (args[1] as String?);
          assert(arg_permission != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale was null, expected non-null String.');
          final bool output = api.shouldShowRequestPermissionRationale(
              arg_instanceId!, arg_permission!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission was null, expected non-null String.');
          final String? arg_permission = (args[1] as String?);
          assert(arg_permission != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission was null, expected non-null String.');
          final int output =
              api.checkSelfPermission(arg_instanceId!, arg_permission!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions was null, expected non-null String.');
          final List<String?>? arg_permissions =
              (args[1] as List<Object?>?)?.cast<String?>();
          assert(arg_permissions != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions was null, expected non-null List<String?>.');
          final PermissionRequestResult output =
              await api.requestPermissions(arg_instanceId!, arg_permissions!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivity',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivity was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivity was null, expected non-null String.');
          final String? arg_intentInstanceId = (args[1] as String?);
          assert(arg_intentInstanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivity was null, expected non-null String.');
          api.startActivity(arg_instanceId!, arg_intentInstanceId!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.getPackageName',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.getPackageName was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.getPackageName was null, expected non-null String.');
          final String output = api.getPackageName(arg_instanceId!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivityForResult',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivityForResult was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivityForResult was null, expected non-null String.');
          final String? arg_intentInstanceId = (args[1] as String?);
          assert(arg_intentInstanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivityForResult was null, expected non-null String.');
          final ActivityResultPigeon output = await api.startActivityForResult(
              arg_instanceId!, arg_intentInstanceId!);
          return <Object?>[output];
        });
      }
    }
  }
}

/// Host API for `Context`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/Context.
abstract class ContextTestHostApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  /// Determine whether the application has been granted a particular permission.
  ///
  /// See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
  int checkSelfPermission(String instanceId, String permission);

  /// Launch a new activity.
  ///
  /// See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
  void startActivity(String instanceId, String intentInstanceId);

  /// Returns the name of this application's package.
  ///
  /// See https://developer.android.com/reference/android/content/Context#getPackageName().
  String getPackageName(String instanceId);

  static void setup(ContextTestHostApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ContextHostApi.checkSelfPermission',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.checkSelfPermission was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.checkSelfPermission was null, expected non-null String.');
          final String? arg_permission = (args[1] as String?);
          assert(arg_permission != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.checkSelfPermission was null, expected non-null String.');
          final int output =
              api.checkSelfPermission(arg_instanceId!, arg_permission!);
          return <Object?>[output];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ContextHostApi.startActivity',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.startActivity was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.startActivity was null, expected non-null String.');
          final String? arg_intentInstanceId = (args[1] as String?);
          assert(arg_intentInstanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.startActivity was null, expected non-null String.');
          api.startActivity(arg_instanceId!, arg_intentInstanceId!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.ContextHostApi.getPackageName',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.getPackageName was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.ContextHostApi.getPackageName was null, expected non-null String.');
          final String output = api.getPackageName(arg_instanceId!);
          return <Object?>[output];
        });
      }
    }
  }
}

/// Host API for `Uri`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/net/Uri.
abstract class UriTestHostApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  /// Creates a Uri which parses the given encoded URI string.
  ///
  /// Returns the instance ID of the created Uri.
  ///
  /// See https://developer.android.com/reference/android/net/Uri#parse(java.lang.String).
  void parse(String instanceId, String uriString);

  /// Returns the encoded string representation of this URI.
  ///
  /// Example: "http://google.com/".
  ///
  /// Method name is [toStringAsync] as opposed to [toString], as [toString]
  /// cannot be overridden with return type [Future].
  ///
  /// See https://developer.android.com/reference/android/net/Uri#toString().
  String toStringAsync(String instanceId);

  static void setup(UriTestHostApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.UriHostApi.parse',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.UriHostApi.parse was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.UriHostApi.parse was null, expected non-null String.');
          final String? arg_uriString = (args[1] as String?);
          assert(arg_uriString != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.UriHostApi.parse was null, expected non-null String.');
          api.parse(arg_instanceId!, arg_uriString!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.UriHostApi.toStringAsync',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.UriHostApi.toStringAsync was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.UriHostApi.toStringAsync was null, expected non-null String.');
          final String output = api.toStringAsync(arg_instanceId!);
          return <Object?>[output];
        });
      }
    }
  }
}

/// Host API for `Intent`.
///
/// This class may handle instantiating and adding native object instances that
/// are attached to a Dart instance or handle method calls on the associated
/// native class or an instance of the class.
///
/// See https://developer.android.com/reference/android/content/Intent.
abstract class IntentTestHostApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding =>
      TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  /// Creates an empty intent.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#Intent().
  void create(String instanceId);

  /// Set the general action to be performed.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setAction(java.lang.String).
  void setAction(String instanceId, String action);

  /// Set the data this intent is operating on.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#setData(android.net.Uri).
  void setData(String instanceId, String uriInstanceId);

  /// Add a new category to the intent.
  ///
  /// Categories provide additional detail about the action the intent performs.
  /// When resolving an intent, only activities that provide all of the
  /// requested categories will be used.
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addCategory(java.lang.String).
  void addCategory(String instanceId, String category);

  /// Add additional flags to the intent (or with existing flags value).
  ///
  /// See https://developer.android.com/reference/android/content/Intent#addFlags(int).
  void addFlags(String instanceId, int flags);

  static void setup(IntentTestHostApi? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.IntentHostApi.create',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.create was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.create was null, expected non-null String.');
          api.create(arg_instanceId!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.IntentHostApi.setAction',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setAction was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setAction was null, expected non-null String.');
          final String? arg_action = (args[1] as String?);
          assert(arg_action != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setAction was null, expected non-null String.');
          api.setAction(arg_instanceId!, arg_action!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.IntentHostApi.setData',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setData was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setData was null, expected non-null String.');
          final String? arg_uriInstanceId = (args[1] as String?);
          assert(arg_uriInstanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.setData was null, expected non-null String.');
          api.setData(arg_instanceId!, arg_uriInstanceId!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.IntentHostApi.addCategory',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addCategory was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addCategory was null, expected non-null String.');
          final String? arg_category = (args[1] as String?);
          assert(arg_category != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addCategory was null, expected non-null String.');
          api.addCategory(arg_instanceId!, arg_category!);
          return <Object?>[];
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.permission_handler_android.IntentHostApi.addFlags',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(channel,
                (Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addFlags was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_instanceId = (args[0] as String?);
          assert(arg_instanceId != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addFlags was null, expected non-null String.');
          final int? arg_flags = (args[1] as int?);
          assert(arg_flags != null,
              'Argument for dev.flutter.pigeon.permission_handler_android.IntentHostApi.addFlags was null, expected non-null int.');
          api.addFlags(arg_instanceId!, arg_flags!);
          return <Object?>[];
        });
      }
    }
  }
}
