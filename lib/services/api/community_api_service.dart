import '../../models/community.dart';
import 'api.dart';
import 'api_service.dart';

class CommunityAPIService extends APIService<Community> {
  const CommunityAPIService(this.api);
  final API api;
  Endpoint get endpoint => Endpoint.community;

  Future<Community> getById(String id) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Community.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }
}
