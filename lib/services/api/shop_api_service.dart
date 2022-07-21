import 'dart:convert';
import 'dart:developer' as dev;

import '../../models/operating_hours.dart';
import '../../models/post_requests/shared/report.dart';
import '../../models/post_requests/shop/operating_hours.request.dart';
import '../../models/post_requests/shop/shop_create.request.dart';
import '../../models/post_requests/shop/shop_summary.request.dart';
import '../../models/post_requests/shop/shop_update.request.dart';
import '../../models/shop.dart';
import '../../models/shop_summary.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class ShopAPIService extends APIService<Shop> {
  factory ShopAPIService(API api, {LokalHttpClient? client}) {
    return ShopAPIService._(
      api,
      _OperatingHoursAPIService(api, client: client),
      _ShopSummaryAPIService(api, client: client),
      client: client,
    );
  }

  ShopAPIService._(
    this.api,
    this._operatingHoursService,
    this._shopSummaryAPIService, {
    LokalHttpClient? client,
  }) : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.shop;
  final _OperatingHoursAPIService _operatingHoursService;
  final _ShopSummaryAPIService _shopSummaryAPIService;

  // --POST
  Future<Shop> create({
    required ShopCreateRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> report({
    required String shopId,
    required Report report,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [shopId, 'report'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(report),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ShopSummary> shopSummary(
    String shopId, {
    required ShopSummaryRequest request,
  }) async =>
      _shopSummaryAPIService.shopSummary(shopId, request: request);

  // --PUT
  Future<bool> update({
    required ShopUpdateRequest request,
    required String id,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setOperatingHours({
    required OperatingHoursRequest request,
    required String id,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [id, 'operatingHours']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET
  Future<Shop> getById({required String id}) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Shop>> getCommunityShops({
    required String communityId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'shops'],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Shop>> getByUserId({
    required String userId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'shops']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OperatingHours> getOperatingHours({required String shopId}) =>
      _operatingHoursService.getOperatingHours(shopId: shopId);

  Future<List<Shop>> getAvailableShops({
    required String communityId,
  }) async {
    try {
      final response = await client.get(
        api.baseUri(
          pathSegments: ['availableShops'],
          queryParameters: <String, String>{'community_id': communityId},
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }

    // the code below is for when the API endpoint follows the documentation

    // try {
    //   final response = await this.client.get(
    //     api.baseUri(
    //       pathSegments: ['availableShops'],
    //       queryParameters: <String, String>{'community_id': communityId},
    //     ),
    //     headers: api.authHeader(),
    //   );

    //   if (response.statusCode == 200) {
    //     final map = json.decode(response.body);
    //     final _availableShops = <ShopModel>[];
    //     final _unavailableShops = <ShopModel>[];

    //     for (final data in map['data']) {
    //       final _shop = ShopModel.fromJson(data);
    //       _availableShops.add(_shop);
    //     }
    //     for (final data in map['unavailable_shops']) {
    //       final _shop = ShopModel.fromJson(data);
    //       _unavailableShops.add(_shop);
    //     }

    //     return {
    //       'available_shops': _availableShops,
    //       'unavailable_shops': _unavailableShops,
    //     };
    //   } else {
    //     final map = json.decode(response.body);
    //     if (map['data'] != null) {
    //       throw throw (FailureException(map['data']));
    //     }

    //     if (map['message'] != null) {
    //       throw FailureException(map['message']);
    //     }

    //     throw FailureException(response.reasonPhrase ?? 'Error parsing data.');
    //   }
    // } on FormatException {
    //   throw FailureException('Bad response format');
    // } catch (e) {
    //   rethrow;
    // }
  }
}

class _OperatingHoursAPIService extends APIService<OperatingHours> {
  _OperatingHoursAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;

  Future<OperatingHours> getOperatingHours({
    required String shopId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(
          Endpoint.shop,
          pathSegments: [
            shopId,
            'operatingHours',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => OperatingHours.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }
}

class _ShopSummaryAPIService extends APIService<ShopSummary> {
  _ShopSummaryAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;

  Future<ShopSummary> shopSummary(
    String shopId, {
    required ShopSummaryRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          Endpoint.shop,
          pathSegments: [shopId, 'summary'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(request),
      );

      dev.log(shopId);
      dev.log(request.toJson().toString());
      dev.log(response.body);

      return handleResponse((map) => ShopSummary.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }
}
