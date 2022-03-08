import 'dart:convert';

import '../../models/lokal_category.dart';
import 'api.dart';
import 'api_service.dart';

class CategoryAPIService extends APIService<LokalCategory> {
  const CategoryAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.category;

  //#region --GET
  Future<List<LokalCategory>> getAll() async {
    try {
      final response = await getter(
        api.endpointUri(endpoint),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => LokalCategory.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LokalCategory> getById({required String id}) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );
      return handleResponse((map) => LokalCategory.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<bool> create({required Map<String, dynamic> body}) async {
    try {
      final response = await poster(
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
  Future<bool> udpate({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await putter(
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
      final response = await deleter(
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
