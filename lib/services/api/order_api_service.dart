import 'dart:convert';

import '../../models/failure_exception.dart';
import '../../models/order.dart';
import '../../models/post_requests/orders/order_create.request.dart';
import '../../models/post_requests/orders/order_pay.request.dart';
import '../../models/post_requests/orders/order_review.request.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class OrderAPIService extends APIService<Order> {
  OrderAPIService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.order;

  //#region --GET
  Future<List<OrderProduct>> getOrderProductsReviews({
    required String orderId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [orderId, 'reviews']),
        headers: api.authHeader(),
      );
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        final List<OrderProduct> reviews = [];

        for (final data in map['data']) {
          final review = OrderProduct.fromJson(data);
          reviews.add(review);
        }
        return reviews;
      } else {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw throw FailureException(map['data']);
        }

        if (map['message'] != null) {
          throw FailureException(map['message']);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region --POST
  Future<Order> create({
    required OrderCreateRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleResponse((map) => Order.fromJson(map), response);
    } on FormatException catch (_) {
      throw FailureException('Bad response format');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addReview({
    required String orderId,
    required String productId,
    required OrderReviewRequest request,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [orderId, 'products', productId, 'review'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(request.toJson()),
      );
      return handleGenericResponse(response);
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
      final response = await client.put(
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
      final response = await client.put(
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
      final response = await client.put(
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
    String reason = '',
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [orderId, 'decline']),
        headers: api.withBodyHeader(),
        body: json.encode({'reason': reason}),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> pay({
    required String orderId,
    required OrderPayRequest request,
  }) async {
    try {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [orderId, 'pay']),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
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
      final response = await client.put(
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
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [orderId, 'shipOut']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      final response = await client.put(
        api.endpointUri(endpoint, pathSegments: [orderId, 'shipOut']),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    }
  }
  //#endregion
}
