import 'dart:convert';

import 'package:http/http.dart' as http;

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
    var response = await http.post(
      api.endpointUri(endpoint),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleResponse((map) => ShopModel.fromMap(map), response);
  }

  // --PUT
  Future<bool> update({
    required Map body,
    required String id,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [id]),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }

  Future<bool> setOperatingHours({
    required Map body,
    required String id,
  }) async {
    final response = await http.put(
      api.endpointUri(endpoint, pathSegments: [id, 'operatingHours']),
      headers: api.withBodyHeader(),
      body: json.encode(body),
    );

    return handleGenericResponse(response);
  }

  // --GET

  Future<http.Response> getById({
    required String shopId,
    required String idToken,
  }) async {
    return await http.get(
      api.endpointUri(endpoint, pathSegments: [shopId]),
      headers: api.authHeader(),
    );
  }

  Future<List<ShopModel>> getShopsByCommunity({
    required String communityId,
  }) async {
    final response = await http.get(
      api.endpointUri(Endpoint.community, pathSegments: [communityId, 'shops']),
      headers: api.authHeader(),
    );

    return handleResponseList((map) => ShopModel.fromMap(map), response);
  }

  Future<List<ShopModel>> getByUserId({
    required String userId,
    required String idToken,
  }) async {
    final response = await http.get(
      api.endpointUri(Endpoint.user, pathSegments: [userId, 'shops']),
      headers: api.authHeader(),
    );

    return handleResponseList((map) => ShopModel.fromMap(map), response);
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
    final response = await http.get(
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
  }
}
