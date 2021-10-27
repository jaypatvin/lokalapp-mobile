//TODO: create community API service

import 'package:lokalapp/services/api/api_service.dart';

import 'api.dart';

class CommunityAPIService extends APIService {
  const CommunityAPIService(this.api);
  final API api;
  static const Endpoint endpoint = Endpoint.community;
}
