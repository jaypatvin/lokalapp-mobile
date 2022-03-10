import 'dart:convert';

import '../../models/operating_hours.dart';
import '../../models/shop.dart';
import 'api.dart';
import 'api_service.dart';

class ShopAPIService extends APIService<Shop> {
  factory ShopAPIService(API api) {
    return ShopAPIService._(api, _OperatingHoursAPIService(api));
  }

  const ShopAPIService._(this.api, this._operatingHoursService);

  final API api;
  Endpoint get endpoint => Endpoint.shop;
  final _OperatingHoursAPIService _operatingHoursService;

  // --POST
  Future<Shop> create({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleResponse((map) => Shop.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> update({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setOperatingHours({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(endpoint, pathSegments: [id, 'operatingHours']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(body)),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET
  Future<Shop> getById({required String id}) async {
    try {
      final response = await getter(
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
      final response = await getter(
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
      final response = await getter(
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
      final response = await getter(
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
    //   final response = await this.getter(
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
  const _OperatingHoursAPIService(this.api);
  final API api;

  Future<OperatingHours> getOperatingHours({
    required String shopId,
  }) async {
    try {
      final response = await getter(
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
