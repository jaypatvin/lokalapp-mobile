/// A class for the App's Exception
class FailureException implements Exception {
  final String message;

  FailureException(this.message);

  @override
  String toString() => message;
}
