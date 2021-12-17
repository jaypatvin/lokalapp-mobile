import 'dart:convert';

import '../../models/lokal_category.dart';
import 'api.dart';
import 'api_service.dart';

class CategoryAPIService extends APIService<LokalCategory> {
  const CategoryAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.category;

  //#region --GET
  Future<List<LokalCategory>> getAll() async {
    try {
      final response = await this.getter(
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
      final response = await this.getter(
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
      final response = await this.poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
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
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.withBodyHeader(),
        body: json.encode(body),
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
      final response = await this.deleter(
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
