/// An exception thrown when the Android activity is missing.
class MissingAndroidActivityException implements Exception {
  /// Creates a new instance of [MissingAndroidActivityException].
  const MissingAndroidActivityException();

  @override
  String toString() =>
      'MissingAndroidActivityException: There is no attached activity';
}
