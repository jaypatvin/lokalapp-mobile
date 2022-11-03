import 'dart:convert';

import '../../models/failure_exception.dart';
import '../../models/operating_hours.dart';
import '../../models/post_requests/product/product_create.request.dart';
import '../../models/post_requests/product/product_review.request.dart';
import '../../models/post_requests/product/product_update.request.dart';
import '../../models/post_requests/shared/report.dart';
import '../../models/post_requests/shop/operating_hours.request.dart';
import '../../models/product.dart';
import '../../models/product_review.dart';
import 'api.dart';
import 'api_service.dart';
import 'client/lokal_http_client.dart';

class ProductApiService extends APIService<Product> {
  ProductApiService(this.api, {LokalHttpClient? client})
      : super(client: client ?? LokalHttpClient());

  final API api;
  Endpoint get endpoint => Endpoint.product;

  // --POST
  Future<Product> create({
    required ProductCreateRequest request,
  }) async {
    try {
      final response = await client.post(
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
      final response = await client.post(
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
      final response = await client.post(
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
      final response = await client.post(
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

  Future<bool> report({
    required String productId,
    required Report report,
  }) async {
    try {
      final response = await client.post(
        api.endpointUri(
          endpoint,
          pathSegments: [productId, 'report'],
        ),
        headers: api.withBodyHeader(),
        body: json.encode(report),
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
      final response = await client.put(
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
      final response = await client.put(
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
      final response = await client.get(
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
      final response = await client.get(
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
      final response = await client.get(
        api.endpointUri(
          Endpoint.user,
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
      final response = await client.get(
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
      final response = await client.get(
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
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [productId]),
        headers: api.authHeader(),
      );

      return handleResponse((map) => Product.fromJson(map), response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OperatingHours> getAvailability({
    required String productId,
  }) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [productId, 'availability']),
        headers: api.authHeader(),
      );

      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        return OperatingHours.fromJson(map['data']!);
      } else {
        final map = json.decode(response.body);
        if (map['data'] != null) {
          throw FailureException(map['data'], response);
        }

        if (map['message'] != null) {
          throw FailureException(map['message'], response);
        }

        throw FailureException(
          response.reasonPhrase ?? 'Error parsing data.',
          response,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductReview>> getReviews({required String productId}) async {
    try {
      final response = await client.get(
        api.endpointUri(endpoint, pathSegments: [productId, 'reviews']),
        headers: api.authHeader(),
      );
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        final List<ProductReview> reviews = [];

        for (final data in map['data']) {
          final review = ProductReview.fromJson(data);
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

  // -- DELETE
  Future<bool> deleteProduct({
    required String productId,
  }) async {
    try {
      final response = await client.delete(
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
      final response = await client.delete(
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
      final response = await client.delete(
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
