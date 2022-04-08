import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../models/failure_exception.dart';

/// A wrapper for the http.Client class from package:http
class LokalHttpClient {
  LokalHttpClient({http.BaseClient? client}) : client = client ?? http.Client();

  final http.Client client;

  /// A wrapper for `http.client.get` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  Future<http.Response> get(
    Uri endpointUri, {
    required Map<String, String> headers,
  }) async {
    try {
      return await client.get(
        endpointUri,
        headers: headers,
      );
    } on SocketException {
      throw FailureException('No Internet Connection!');
    } on HttpException {
      throw FailureException('Failed lookup!');
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  /// A wrapper for `http.post` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  Future<http.Response> post(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await client.post(
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
    } finally {
      client.close();
    }
  }

  /// A wrapper for `http.delete` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  Future<http.Response> delete(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await client.delete(
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
    } finally {
      client.close();
    }
  }

  /// A wrapper for `http.put` that throws corresponding apprioriate
  /// `[SocketException]` or `[HttpException]` error messages.
  ///
  /// Only accepts `"application/json"` as encoding (can be included in header).
  Future<http.Response> put(
    Uri endpointUri, {
    Map<String, String>? headers,
    String? body,
    Encoding? encoding,
  }) async {
    try {
      return await client.put(
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
    } finally {
      client.close();
    }
  }
}
