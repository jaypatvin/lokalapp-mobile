import 'dart:convert';

import '../../models/failure_exception.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class SearchAPIService extends APIService {
  SearchAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.search;

  Future<Map<String, List<String>>> search({
    required String query,
    required String communityId,
    List<String>? criteria,
    String? category,
  }) async {
    final qp = <String, dynamic>{
      'q': query,
      'community_id': communityId,
    };
    if (criteria != null) qp['criteria'] = [...criteria];
    if (category != null) qp['category'] = category;

    try {
      final response = await client.get(
        api.endpointUri(
          endpoint,
          queryParameters: qp,
        ),
        headers: api.authHeader(),
      );

      if (response.statusCode == 200) {
        final result = <String, List<String>>{};
        final map = json.decode(response.body);
        final data = map['data'] as Map<String, dynamic>;

        if (data['products'] == null && data['shops'] == null) {
          throw 'no-results';
        }

        if (data['products'] != null) {
          final products = List<String>.from(
            data['products']?.map((x) => x['id']) ?? [],
          );

          result['products'] = products;
        }

        if (data['shops'] != null) {
          final shops = List<String>.from(
            data['shops']?.map((x) => x['id']) ?? [],
          );

          result['shops'] = shops;
        }

        return result;
      } else {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw FailureException(map['data']);
        }

        if (map['message'] != null) {
          throw FailureException(map['message']);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response.body,
        );
      }
    } on FormatException catch (e) {
      throw FailureException('Bad Response Format', e);
    } catch (e) {
      rethrow;
    }
  }
}
