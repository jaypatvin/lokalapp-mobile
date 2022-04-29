import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/lokal_category.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class CategoryAPI {
  Endpoint get endpoint => Endpoint.category;
  
  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

  //#region --GET
  Future<List<LokalCategory>> getAll() async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => LokalCategory.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LokalCategory> getById({required String id}) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );
      return handleResponse((map) => LokalCategory.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<bool> create({required Map<String, dynamic> body}) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --PUT
  Future<bool> update({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --DELETE
  Future<bool> delete({required String id}) async {
    try {
      final response = await client.delete(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion
}
