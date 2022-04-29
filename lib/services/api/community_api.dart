import '../../app/app.locator.dart';
import '../../models/community.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class CommunityAPI {
  Endpoint get endpoint => Endpoint.community;

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();

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
}
