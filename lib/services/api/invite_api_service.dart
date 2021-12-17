import 'dart:convert';

import '../../models/lokal_invite.dart';
import 'api.dart';
import 'api_service.dart';

class InviteAPIService extends APIService<LokalInvite> {
  const InviteAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.invite;

  Future<LokalInvite> inviteAFriend(Map<String, dynamic> body) async {
    try {
      final response = await this.poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse((map) => LokalInvite.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LokalInvite> check(String code) async {
    try {
      final response = await this.getter(
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
    required String userId,
    required String code,
  }) async {
    try {
      final response = await this.poster(
        api.endpointUri(endpoint, pathSegments: ['claim']),
        headers: api.withBodyHeader(),
        body: json.encode({
          'user_id': userId,
          'code': code,
        }),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
