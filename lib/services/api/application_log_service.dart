import 'dart:convert';

import '../../app/app.locator.dart';
import '../../models/post_requests/shared/application_log.dart';
import '../api_service.dart';
import 'api.dart';
import 'client/lokal_http_client.dart';

class ApplicationLogsService {
  ApplicationLogsService();

  final APIService api = locator<APIService>();
  final client = locator<LokalHttpClient>();
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
