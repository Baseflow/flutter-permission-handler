import 'android_object_mirrors/activity.dart';

/// An exception thrown when no [Activity] is attached.
///
/// This can happen if the app is running in the background, for example.
class MissingActivityException implements Exception {
  /// Creates a new instance of [MissingActivityException].
  const MissingActivityException();

  @override
  String toString() =>
      'MissingActivityException: There is no attached activity';
}
