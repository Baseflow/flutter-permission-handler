import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MethodChannelMock {
  final MethodChannel methodChannel;
  final String method;
  final dynamic result;
  final Duration delay;

  MethodChannelMock({
    required String channelName,
    required this.method,
    this.result,
    this.delay = Duration.zero,
  }) : methodChannel = MethodChannel(channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, _handler);
  }

  Future _handler(MethodCall methodCall) async {
    if (methodCall.method != method) {
      throw MissingPluginException('No implementation found for method '
          '$method on channel ${methodChannel.name}');
    }

    return Future.delayed(delay, () {
      if (result is Exception) {
        throw result;
      }

      return Future.value(result);
    });
  }
}
