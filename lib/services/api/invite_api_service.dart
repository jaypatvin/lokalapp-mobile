import 'dart:convert';
import 'dart:developer';

import '../../models/lokal_invite.dart';
import 'api.dart';
import 'api_service.dart';

class InviteAPIService extends APIService<LokalInvite> {
  const InviteAPIService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.invite;

  Future<LokalInvite> inviteAFriend(Map<String, dynamic> body) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleResponse((map) => LokalInvite.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LokalInvite> check(String code) async {
    try {
      final response = await getter(
        api.endpointUri(
          endpoint,
          pathSegments: ['check', code],
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => LokalInvite.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> claim({
    required String code,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint, pathSegments: ['claim']),
        headers: api.withBodyHeader(),
        body: json.encode({
          'code': code,
        }),
      );

      log(response.body);

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
