import 'dart:convert';

import '../../models/post_requests/shared/application_log.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class ApplicationLogsService extends APIService {
  ApplicationLogsService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.applicationLogs;

  Future<bool> log({required ApplicationLog log}) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(log),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
