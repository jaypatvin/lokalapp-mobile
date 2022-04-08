import 'dart:convert';

import '../../models/lokal_invite.dart';
import '../../models/post_requests/invite.request.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class InviteAPIService extends APIService<LokalInvite> {
  InviteAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.invite;

  Future<LokalInvite> inviteAFriend(String email) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode({'email': email}),
      );

      return handleResponse((map) => LokalInvite.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LokalInvite> check(String code) async {
    try {
      final response = await client.get(
        api.endpointUri(
          endpoint,
          pathSegments: ['check', code],
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => LokalInvite.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> claim({
    required InviteRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint, pathSegments: ['claim']),
        headers: api.withBodyHeader(),
        body: json.encode(request),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
