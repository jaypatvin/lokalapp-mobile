import 'package:flutter/foundation.dart';

/// The different endpoints for api access
enum Endpoint {
  /// API endpoint for different activity operations
  activity,

  /// API endpoint for different category operations
  category,

  /// API endpoint for different chat operations
  chat,

  /// API endpoint for different community operations
  community,

  /// API endpoint for different invite operations
  invite,

  /// API endpoint for different order operations
  order,

  /// API endpoint for different product operations
  product,

  /// API endpoint for search operations
  search,

  /// API endpoint for different shop operations
  shop,

  /// API endpoint for different productSubscriptionPlan operations
  subscription_plan,

  /// API endpoint for different user operations
  user,
}

/// Extension class that gives the path for the given Endpoint
extension EndpointPath on Endpoint {
  /// The equivalent pathSegment for the given Endpoint
  String get path {
    switch (this) {
      case Endpoint.activity:
        return 'activities';
      case Endpoint.category:
        return 'categories';
      case Endpoint.chat:
        return 'chats';
      case Endpoint.community:
        return 'community';
      case Endpoint.invite:
        return 'invite';
      case Endpoint.order:
        return 'orders';
      case Endpoint.product:
        return 'products';
      case Endpoint.search:
        return 'search';
      case Endpoint.shop:
        return 'shops';
      case Endpoint.subscription_plan:
        return 'productSubscriptionPlans';
      case Endpoint.user:
        return 'users';
    }
  }
}

/// Responsible for handling the different API Endpoints.
class API extends ChangeNotifier {
  /// `accessToken` will be refreshed by the backend
  API({this.idToken});

  /// IdToken from FirebaseAuth
  String? idToken;

  /// The base host string for our API endpoints
  static const String host = 'us-central1-lokal-1baac.cloudfunctions.net';

  void setIdToken(String token) {
    this.idToken = token;
    notifyListeners();
  }

  /// Returns the endpoint Uri from the given `Endpoint`.
  ///
  /// `endpoint` is required to determine the Uri. `pathSegments` are appended
  /// at the end of the endpoint Uri path.
  ///
  /// `endpointUri(Endpoint.activity, pathSegments: [activityId])`
  /// will return the Uri with path: `host/api/v1/activities/activityId`
  Uri endpointUri(
    Endpoint endpoint, {
    List<String> pathSegments = const [],
    Map<String, dynamic> queryParameters = const {},
  }) =>
      baseUri(
        pathSegments: [endpoint.path, ...pathSegments],
        queryParameters: queryParameters,
      );

  /// Returns the base endpoint Uri.
  ///
  /// `pathSegments` are appended at the end of the endpoint Uri path.
  /// `endpointUri(pathSegments: [activities])`
  /// will return the Uri with path: `host/api/v1/activities`
  Uri baseUri({
    List<String> pathSegments = const [],
    Map<String, dynamic> queryParameters = const {},
  }) =>
      Uri(
        scheme: 'https',
        host: host,
        pathSegments: ['api', 'v1', ...pathSegments],
        queryParameters: queryParameters,
      );

  /// Returns the needed header when auth is only needed
  Map<String, String> authHeader() =>
      idToken != null ? {'Authorization': 'Bearer $idToken'} : const {};

  /// Returns the needed header when a payload will be sent
  Map<String, String> withBodyHeader() => {
        'Content-Type': 'application/json',
        ...authHeader(),
      };

  /// Returns a custom header with the `authHeader` already included.
  Map<String, String> customheader({Map<String, String>? map}) => {
        ...authHeader(),
        ...?map,
      };
}
