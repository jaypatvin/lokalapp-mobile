import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/failure_exception.dart';
import 'client/lokal_http_client.dart';

/// Class that supports handling of responses.
///
/// `T` is an object that will be created from the http response.
abstract class APIService<T> {
  const APIService({required this.client});
  final LokalHttpClient client;

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

  /// Removes empty/null keys and values from the map.
  ///
  /// This function also trims maps recursively: empty/null keys and values from
  /// submaps are also removed (and checked again if is empty)
  @protected
  Map<String, dynamic>? trimBodyFields(Map<String, dynamic>? body) {
    final Map<String, dynamic>? _body;
    if (body != null) {
      _body = {...body};
    } else {
      _body = null;
    }

    for (final entry in body?.entries ?? {}.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key.isEmpty || value == null) {
        _body?.remove(key);
        continue;
      }

      if (value is String) {
        if (value.isEmpty) _body?.remove(key);
        continue;
      } else if (value is List) {
        if (value.isEmpty) _body?.remove(key);
        continue;
      } else if (value is Map) {
        final _value = trimBodyFields({...value});
        if (_value?.isEmpty ?? true) {
          _body?.remove(key);
        } else {
          _body?[key] = _value;
        }
        continue;
      }
    }

    return _body;
  }
}
