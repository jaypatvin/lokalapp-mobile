import 'dart:convert';

import '../../models/community.dart';
import '../../models/post_requests/shared/report.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class CommunityAPIService extends APIService<Community> {
  CommunityAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.community;

  Future<Community> getById(String id) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Community.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> report({
    required String communityid,
    required Report report,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [communityid, 'report'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(report),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
