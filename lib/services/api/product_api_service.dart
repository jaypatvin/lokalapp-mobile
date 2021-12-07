import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/product.dart';
import 'api.dart';
import 'api_service.dart';

class ProductApiService extends APIService<Product> {
  const ProductApiService(this.api);

  final API api;
  final Endpoint endpoint = Endpoint.product;

  // --POST
  Future<Product> create({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleResponse((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> rate({
    required String productId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'ratings'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> like({required String productId}) async {
    try {
      final response = await http.post(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'like'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addToWishlist({required String productId}) async {
    try {
      final response = await http.post(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'wishlist'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --PUT
  Future<bool> update({
    required String productId,
    required Map body,
  }) async {
    try {
      final response = await http.put(
        api.endpointUri(
          endpoint,
          pathSegments: [
            productId,
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setAvailability({
    required String productId,
    required Map body,
  }) async {
    try {
      final response = await http.put(
        api.endpointUri(
          endpoint,
          pathSegments: [
            productId,
            'availability',
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(body),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // --GET
  Future<List<Product>> getCommunityProducts({
    required String communityId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [
            communityId,
            'products',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getAvailableProducts() async {
    try {
      final response = await http.get(
        api.baseUri(pathSegments: const ['availableProducts']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getUserProducts({
    required String userId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [
            userId,
            'products',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getRecommendedProducts({
    required String userId,
    required String communityId,
  }) async {
    try {
      final response = await http.get(
        api.baseUri(
          pathSegments: ['recommendedProducts'],
          queryParameters: {
            'user_id': userId,
            'community_id': communityId,
          },
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getUserWishlist({
    required String userId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'wishlist']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getById({
    required String productId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint, pathSegments: [productId]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getAvailability({
    required String productId,
  }) async {
    try {
      final response = await http.get(
        api.endpointUri(endpoint, pathSegments: [productId, 'availability']),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Product.fromMap(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // -- DELETE
  Future<bool> deleteProduct({
    required String productId,
  }) async {
    try {
      final response = await http.delete(
        api.endpointUri(endpoint, pathSegments: [productId]),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlike({required productId}) async {
    try {
      final response = await http.delete(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'unlike'],
        ),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removeFromWishlist({required productId}) async {
    try {
      final response = await http.delete(
          api.endpointUri(
            endpoint,
            pathSegments: [productId, 'wishlist'],
          ),
          headers: api.authHeader());

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
