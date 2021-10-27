import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api.dart';
import 'api_service.dart';

class InviteAPIService extends APIService {
  const InviteAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.invite;

  Future<bool> check(String code) async {
    final response = await http.get(
      api.endpointUri(
        endpoint,
        pathSegments: ['check', code],
      ),
      headers: api.authHeader(),
    );

    return handleGenericResponse(response);
  }

  Future<bool> claim({
    required String userId,
    required String code,
  }) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode({
        "user_id": userId,
        "code": code,
      }),
    );

    return handleGenericResponse(response);
  }
}
