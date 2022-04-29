import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/lokal_invite.dart';
import '../../models/post_requests/invite.request.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class InviteAPI {
  Endpoint get endpoint => Endpoint.invite;

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

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
