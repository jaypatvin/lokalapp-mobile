import 'dart:convert';

import 'package:http/http.dart' as http;

/// Class that supports handling of responses.
///
/// `T` is an object that will be created from the http response.
abstract class APIService<T> {
  const APIService();

  /// Returns an object `T` from the given response.
  ///
  /// Typically, the response will include a `data` field with the the
  /// map of object T.
  /// Will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  T handleResponse(
    T Function(Map<String, dynamic>) fromMap,
    http.Response response,
  ) {
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return fromMap(map['data']!);
    } else {
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw map['data'];
        }

        if (map['message'] != null) {
          throw map['message'];
        }

        throw response.reasonPhrase!;
      } on FormatException {
        throw response.reasonPhrase!;
      }
    }
  }

  /// Returns a list of object `T` from the given response.
  ///
  /// Typically, the response will include a `data` field with the list of the
  /// map of the object T.
  /// Will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  List<T> handleResponseList(
    T Function(Map<String, dynamic>) fromMap,
    http.Response response,
  ) {
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      List<T> objects = [];

      for (final data in map['data']) {
        final _activity = fromMap(data);
        objects.add(_activity);
      }
      return objects;
    } else {
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw map['data'];
        }

        if (map['message'] != null) {
          throw map['message'];
        }

        throw response.reasonPhrase!;
      } on FormatException {
        throw response.reasonPhrase!;
      }
    }
  }

  /// Returns `true` or `false` if the operation is successful or not.
  ///
  /// Typically, the only response expected from the operation is
  /// `"status": "ok"` or `"status": "error"`.
  /// This will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  bool handleGenericResponse(http.Response response) {
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return map['status']! == 'ok';
    } else {
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw map['data'];
        }

        if (map['message'] != null) {
          throw map['message'];
        }

        throw '${map["status"]}: ${response.reasonPhrase}';
      } on FormatException {
        throw response.reasonPhrase!;
      }
    }
  }
}
