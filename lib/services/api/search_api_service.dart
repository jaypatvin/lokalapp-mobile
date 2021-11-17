import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api.dart';
import 'api_service.dart';

class SearchAPIService extends APIService {
  const SearchAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.search;

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
    final response = await http.get(
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

      if (data['products'] == null && data['shops'] == null) throw 'no-results';

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
      try {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw map['data'];
        }

        if (map['message'] != null) {
          throw map['message'];
        }

        throw response.reasonPhrase!;
      } on FormatException {
        throw response.reasonPhrase!;
      }
    }
  }
}
