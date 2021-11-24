import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/lokal_invite.dart';
import 'api.dart';
import 'api_service.dart';

class InviteAPIService extends APIService<LokalInvite> {
  const InviteAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.invite;

  Future<LokalInvite> inviteAFriend(Map<String, dynamic> body) async {
    final response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse((map) => LokalInvite.fromMap(map), response);
  }

  Future<LokalInvite> check(String code) async {
    final response = await http.get(
      api.endpointUri(
        endpoint,
        pathSegments: ['check', code],
      ),
      headers: api.authHeader(),
    );

    return handleResponse((map) => LokalInvite.fromMap(map), response);
  }

  Future<bool> claim({
    required String userId,
    required String code,
  }) async {
    final response = await http.post(
      api.endpointUri(endpoint, pathSegments: ['claim']),
      headers: api.withBodyHeader(),
      body: json.encode({
        'user_id': userId,
        'code': code,
      }),
    );

    return handleGenericResponse(response);
  }
}
