import 'dart:convert';

import '../../models/operating_hours.dart';
import '../../models/user_shop.dart';
import 'api.dart';
import 'api_service.dart';

class ShopAPIService extends APIService<ShopModel> {
  const ShopAPIService._(this.api, this._operatingHoursService);

  factory ShopAPIService(API api) {
    return ShopAPIService._(api, _OperatingHoursAPIService(api));
  }

  final API api;
  final Endpoint endpoint = Endpoint.shop;
  final _OperatingHoursAPIService _operatingHoursService;

  // --POST
  Future<ShopModel> create({
    required Map body,
  }) async {
    try {
      final response = await this.poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse((map) => ShopModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> update({
    required Map body,
    required String id,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setOperatingHours({
    required Map body,
    required String id,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [id, 'operatingHours']),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET

  Future<ShopModel> getById({required String id}) async {
    try {
      final response = await this.getter(
        api.endpointUri(endpoint, pathSegments: [id]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => ShopModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShopModel>> getCommunityShops({
    required String communityId,
  }) async {
    try {
      final response = await this.getter(
        api.endpointUri(Endpoint.community,
            pathSegments: [communityId, 'shops']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => ShopModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShopModel>> getByUserId({
    required String userId,
    required String idToken,
  }) async {
    try {
      final response = await this.getter(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'shops']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => ShopModel.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OperatingHours> getOperatingHours({required String shopId}) =>
      _operatingHoursService.getOperatingHours(shopId: shopId);
}

class _OperatingHoursAPIService extends APIService<OperatingHours> {
  const _OperatingHoursAPIService(this.api);
  final API api;

  Future<OperatingHours> getOperatingHours({
    required String shopId,
  }) async {
    try {
      final response = await this.getter(
        api.endpointUri(
          Endpoint.shop,
          pathSegments: [
            shopId,
            'operatingHours',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponse((map) => OperatingHours.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }
}
