/// A class for the App's Exception
class FailureException implements Exception {
  final String message;
  final Object? details;

  FailureException(this.message, [this.details]);

  @override
  String toString() => '$message: ${details ?? "no details given"}.';
}
