import 'package:flutter/services.dart';
import 'package:flutter_instance_manager/flutter_instance_manager.dart';

import '../android_permission_handler_api_impls.dart';

/// Immutable URI reference. A URI reference includes a URI and a fragment, the
/// component of the URI following a '#'. Builds and parses URI references which
/// conform to RFC 2396.
///
/// In the interest of performance, this class performs little to no validation.
/// Behavior is undefined for invalid input. This class is very forgiving--in
/// the face of invalid input, it will return garbage rather than throw an
/// exception unless otherwise specified.
///
/// See https://developer.android.com/reference/android/net/Uri.
class Uri extends JavaObject {
  /// Instantiates a [Uri], creating and attaching it to an instance of the
  /// associated native class.
  ///
  /// For internal use only. Instead, use [Uri.parse].
  Uri._({
    InstanceManager? instanceManager,
    BinaryMessenger? binaryMessenger,
  })  : _hostApi = UriHostApiImpl(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        ),
        super.detached(
          instanceManager: instanceManager,
          binaryMessenger: binaryMessenger,
        );

  final UriHostApiImpl _hostApi;

  /// Creates a [Uri] which parses the given encoded URI string.
  ///
  /// See https://developer.android.com/reference/android/net/Uri#parse(java.lang.String).
  factory Uri.parse(
    String uriString, {
    BinaryMessenger? binaryMessenger,
    InstanceManager? instanceManager,
  }) {
    final Uri uri = Uri._(
      binaryMessenger: binaryMessenger,
      instanceManager: instanceManager,
    );

    uri._hostApi.parseFromInstance(uri, uriString);

    return uri;
  }

  /// Returns the encoded string representation of this URI.
  ///
  /// Example: "http://google.com/".
  ///
  /// See https://developer.android.com/reference/android/net/Uri#toString().
  Future<String> toStringAsync() {
    return _hostApi.toStringAsyncFromInstance(
      this,
    );
  }
}
