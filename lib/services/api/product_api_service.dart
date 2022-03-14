import 'dart:convert';

import '../../models/post_requests/product/product_create.request.dart';
import '../../models/post_requests/product/product_review.request.dart';
import '../../models/post_requests/product/product_update.request.dart';
import '../../models/post_requests/shop/operating_hours.request.dart';
import '../../models/product.dart';
import 'api.dart';
import 'api_service.dart';

class ProductApiService extends APIService<Product> {
  const ProductApiService(this.api);

  final API api;
  Endpoint get endpoint => Endpoint.product;

  // --POST
  Future<Product> create({
    required ProductCreateRequest request,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(endpoint),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );
      return handleResponse((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> review({
    required String productId,
    required ProductReviewRequest request,
  }) async {
    try {
      final response = await poster(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'reviews'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(request.toJson()),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> like({required String productId}) async {
    try {
      final response = await poster(
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
      final response = await poster(
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
    required ProductUpdateRequest request,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(
          endpoint,
          pathSegments: [
            productId,
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setAvailability({
    required String productId,
    required OperatingHoursRequest request,
  }) async {
    try {
      final response = await putter(
        api.endpointUri(
          endpoint,
          pathSegments: [
            productId,
            'availability',
          ],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(trimBodyFields(request.toJson())),
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
      final response = await getter(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [
            communityId,
            'products',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getAvailableProducts() async {
    try {
      final response = await getter(
        api.baseUri(pathSegments: const ['availableProducts']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getUserProducts({
    required String userId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [
            userId,
            'products',
          ],
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getRecommendedProducts({
    required String userId,
    required String communityId,
  }) async {
    try {
      final response = await getter(
        api.baseUri(
          pathSegments: ['recommendedProducts'],
          queryParameters: {
            'user_id': userId,
            'community_id': communityId,
          },
        ),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getUserWishlist({
    required String userId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(Endpoint.user, pathSegments: [userId, 'wishlist']),
        headers: api.authHeader(),
      );

      return handleResponseList((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getById({
    required String productId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [productId]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getAvailability({
    required String productId,
  }) async {
    try {
      final response = await getter(
        api.endpointUri(endpoint, pathSegments: [productId, 'availability']),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  // -- DELETE
  Future<bool> deleteProduct({
    required String productId,
  }) async {
    try {
      final response = await deleter(
        api.endpointUri(endpoint, pathSegments: [productId]),
        headers: api.authHeader(),
      );

      return handleGenericResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlike({required String productId}) async {
    try {
      final response = await deleter(
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

  Future<bool> removeFromWishlist({required String productId}) async {
    try {
      final response = await deleter(
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
}
