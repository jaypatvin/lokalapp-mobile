import 'package:http/http.dart' as http;

import '../../models/community.dart';
import 'api.dart';
import 'api_service.dart';

class CommunityAPIService extends APIService<Community> {
  const CommunityAPIService(this.api);
  final API api;
  static const Endpoint endpoint = Endpoint.community;

  Future<Community> getById(String id) async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Community.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }
}
