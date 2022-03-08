import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/failure_exception.dart';

/// Class that supports handling of responses.
///
/// `T` is an object that will be created from the http response.
abstract class APIService<T> {
  const APIService();

  /// A wrapper for `http.getter` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  @protected
  Future<http.Response> getter(
    Uri endpointUri, {
    required Map<String, String> headers,
  }) async {
    try {
      return await http.get(
        endpointUri,
        headers: headers,
      );
    } on SocketException {
      throw FailureException('No Internet Connection!');
    } on HttpException {
      throw FailureException('Failed lookup!');
    } catch (e) {
      rethrow;
    }
  }

  /// A wrapper for `http.post` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  @protected
  Future<http.Response> poster(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await http.post(
        endpointUri,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on SocketException {
      throw FailureException('No Internet Connection!');
    } on HttpException {
      throw FailureException('Failed lookup!');
    } catch (e) {
      rethrow;
    }
  }

  /// A wrapper for `http.delete` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  @protected
  Future<http.Response> deleter(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await http.delete(
        endpointUri,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on SocketException {
      throw FailureException('No Internet Connection!');
    } on HttpException {
      throw FailureException('Failed lookup!');
    } catch (e) {
      rethrow;
    }
  }

  /// A wrapper for `http.put` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  @protected
  Future<http.Response> putter(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await http.put(
        endpointUri,
        headers: headers,
        body: body,
        encoding: encoding,
      );
    } on SocketException {
      throw FailureException('No Internet Connection!');
    } on HttpException {
      throw FailureException('Failed lookup!');
    } catch (e) {
      rethrow;
    }
  }

  /// Returns an object `T` from the given response.
  ///
  /// Typically, the response will include a `data` field with the the
  /// map of object T.
  /// Will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  @protected
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
          throw FailureException(map['data'], response);
        }

        if (map['message'] != null) {
          throw FailureException(map['message'], response);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response,
        );
      } on FormatException {
        throw FailureException('Bad response format', response.body);
      } catch (e) {
        rethrow;
      }
    }
  }

  /// Returns a list of object `T` from the given response.
  ///
  /// Typically, the response will include a `data` field with the list of the
  /// map of the object T.
  /// Will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  @protected
  List<T> handleResponseList(
    T Function(Map<String, dynamic>) fromMap,
    http.Response response,
  ) {
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final List<T> objects = [];

      for (final data in map['data']) {
        final _activity = fromMap(data);
        objects.add(_activity);
      }
      return objects;
    } else {
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw throw FailureException(map['data']);
        }

        if (map['message'] != null) {
          throw FailureException(map['message']);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response.body,
        );
      } on FormatException {
        throw FailureException('Bad response format', response.body);
      } catch (e) {
        rethrow;
      }
    }
  }

  /// Returns `true` or `false` if the operation is successful or not.
  ///
  /// Typically, the only response expected from the operation is
  /// `"status": "ok"` or `"status": "error"`.
  /// This will throw an error message found in the `response.body`. If there is
  /// no error message, will throw the `response.reasonPhrase`.
  @protected
  bool handleGenericResponse(http.Response response) {
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return map['status']! == 'ok';
    } else {
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw throw FailureException(map['data']);
        }

        if (map['message'] != null) {
          throw FailureException(map['message']);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response.body,
        );
      } on FormatException {
        throw FailureException('Bad response format', response.body);
      } catch (e) {
        rethrow;
      }
    }
  }

  /// Removes empty keys and values from the map.
  @protected
  Map<String, dynamic>? trimBodyFields(Map<String, dynamic>? body) {
    final Map<String, dynamic>? _body;
    if (body != null) {
      _body = {...body};
    } else {
      _body = null;
    }

    _body?.removeWhere((key, value) {
      if (key.isEmpty || value == null) return true;

      if (value is String) {
        return value.isEmpty;
      } else if (value is List) {
        return value.isEmpty;
      }
      return false;
    });

    return _body;
  }
}
