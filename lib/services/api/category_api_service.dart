import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/lokal_category.dart';
import 'api.dart';
import 'api_service.dart';

class CategoryAPIService extends APIService<LokalCategory> {
  const CategoryAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.category;

  //#region --GET
  Future<List<LokalCategory>> getAll() async {
    final response = await http.get(
      api.endpointUri(endpoint),
      headers: api.authHeader(),
    );

    return handleResponseList((map) => LokalCategory.fromMap(map), response);
  }

  Future<LokalCategory> getById({required String id}) async {
    final response = await http.get(
      api.endpointUri(endpoint, pathSegments: [id]),
      headers: api.authHeader(),
    );
    return handleResponse((map) => LokalCategory.fromMap(map), response);
  }
  //#endregion

  //#region --POST
  Future<bool> create({required Map<String, dynamic> body}) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }
  //#endregion

  //#region --PUT
  Future<bool> udpate({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [id]),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }
  //#endregion

  //#region --DELETE
  Future<bool> delete({required String id}) async {
    final response = await http.delete(
      api.endpointUri(endpoint, pathSegments: [id]),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }
  //#endregion
}
