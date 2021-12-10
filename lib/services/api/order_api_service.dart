import 'dart:convert';

import '../../models/order.dart';
import 'api.dart';
import 'api_service.dart';

class OrderAPIService extends APIService<Order> {
  const OrderAPIService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.order;

  //#region --POST
  Future<Order> create({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await this.poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse((map) => Order.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --PUT

  Future<bool> cancel({
    required String orderId,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(
          endpoint,
          pathSegments: [orderId, 'cancel'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirm({
    required String orderId,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'confirm']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmPayment({
    required String orderId,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'confirmPayment']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> decline({
    required String orderId,
    String? reason,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'decline']),
        headers: api.authHeader(),
        body: json.encode({'reason': reason}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> pay({
    required String orderId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'pay']),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> receive({
    required String orderId,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'receive']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> shipOut({
    required String orderId,
  }) async {
    try {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'shipOut']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      final response = await this.putter(
        api.endpointUri(endpoint, pathSegments: [orderId, 'shipOut']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    }
  }
  //#endregion
}
