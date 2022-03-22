import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/activity_feed.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/post_requests/activities/activity.like.request.dart';
import 'package:lokalapp/models/post_requests/activities/activity.request.dart';
import 'package:lokalapp/services/api/activity_api_service.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'activity_api_service_test.mocks.dart';
import 'responses/activity_api_service.responses.dart' as activity;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('[ActivityAPIService]', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = ActivityAPIService(api, client: client);

    const activityId = 'activityId';
    const unusableActivityId = 'unusableActivityId';
    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    when(api.authHeader()).thenReturn(headers);
    when(api.withBodyHeader()).thenReturn(headers);
    when(api.endpointUri(Endpoint.activity)).thenReturn(successUri);
    when(api.endpointUri(Endpoint.activity, pathSegments: [activityId]))
        .thenReturn(successUri);
    when(
      api.endpointUri(Endpoint.activity, pathSegments: [unusableActivityId]),
    ).thenReturn(unsucessfulUri);

    group('getById', () {
      test('returns an ActivityFeed if successful', () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successResponse, 200),
        );

        expect(
          await service.getById(activityId: activityId),
          isA<ActivityFeed>(),
        );
      });

      test(
          'A FailureException Error should be thrown when '
          'wrong ActivityID is given', () async {
        when(client.get(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.error404, 404));

        expect(
          () async => service.getById(activityId: unusableActivityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successMissingResponse, 200),
        );

        expect(
          () async => service.getById(activityId: activityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });

      test('A TimeoutException whould be thrown on timeout', () {
        when(client.get(successUri, headers: headers)).thenThrow(
          TimeoutException('timeout', const Duration(seconds: 2)),
        );

        expect(
          () async => service.getById(activityId: activityId),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    group('getAll', () {
      test('Returns a List of ActivityFeed when successful', () async {
        when(api.endpointUri(Endpoint.activity)).thenReturn(successUri);
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListResponse, 200),
        );

        expect(await service.getAll(), isA<List<ActivityFeed>>());
      });

      test('A FailureException should be thrown on error response', () {
        when(api.endpointUri(Endpoint.activity)).thenReturn(unsucessfulUri);
        when(client.get(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.error404, 404));

        expect(() async => service.getAll(), throwsA(isA<FailureException>()));
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () async {
        when(api.endpointUri(Endpoint.activity)).thenReturn(successUri);
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListMissingResponse, 200),
        );

        expect(
          () async => service.getAll(),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getUserActivities', () {
      const userId = 'userId';
      const nonUserId = 'noSuchUser';
      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [userId, 'activities'],
        ),
      ).thenReturn(successUri);
      when(
        api.endpointUri(
          Endpoint.user,
          pathSegments: [nonUserId, 'activities'],
        ),
      ).thenReturn(unsucessfulUri);
      test('Returns a List of ActivityFeed when successful', () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListResponse, 200),
        );

        expect(
          await service.getUserActivities(userId: userId),
          isA<List<ActivityFeed>>(),
        );
      });

      test('A FailureException should be thrown on error response', () {
        when(client.get(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.error404, 404));

        expect(
          () async => service.getUserActivities(userId: nonUserId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListMissingResponse, 200),
        );

        expect(
          () async => service.getUserActivities(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });
    group('getCommunityActivities', () {
      const communityId = 'communityId';
      const nonCommunityId = 'nonCommunityId';

      when(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [communityId, 'activities'],
        ),
      ).thenReturn(successUri);
      when(
        api.endpointUri(
          Endpoint.community,
          pathSegments: [nonCommunityId, 'activities'],
        ),
      ).thenReturn(unsucessfulUri);
      test('Returns a List of ActivityFeed when successful', () async {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListResponse, 200),
        );

        expect(
          await service.getCommunityActivities(communityId: communityId),
          isA<List<ActivityFeed>>(),
        );
      });

      test('A FailureException should be thrown on error response', () {
        when(client.get(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.error404, 404));

        expect(
          () async =>
              service.getCommunityActivities(communityId: nonCommunityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () {
        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(activity.successListMissingResponse, 200),
        );

        expect(
          () async => service.getCommunityActivities(communityId: communityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('create', () {
      const request = ActivityRequest(
        userId: 'userId',
        message: 'sample message',
      );
      test('An ActivityFeed should be returned upon successful creation',
          () async {
        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.successResponse, 200));

        expect(await service.create(request: request), isA<ActivityFeed>());
      });

      test('A FailureException should be thrown on error response', () {
        when(api.endpointUri(Endpoint.activity)).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.errorCreate, 400));

        expect(
          () async => service.create(request: request),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A FormatException should be thrown on error response with a status 200',
          () {
        when(api.endpointUri(Endpoint.activity)).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.errorCreate, 200));

        expect(
          () async => service.create(request: request),
          throwsException,
        );
      });

      test(
          'A MissingRequiredKeysException should be thrown when the returned '
          'json data is incomplete', () {
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer(
          (_) async => http.Response(activity.successMissingResponse, 200),
        );

        expect(
          () async => service.create(request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('like', () {
      const request = ActivityLikeRequest(userId: 'userId');

      test('Value [true] should be return when successful', () async {
        when(
          api.endpointUri(Endpoint.activity,
              pathSegments: [activityId, 'like']),
        ).thenReturn(successUri);
        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.okStatus, 200));

        expect(
          await service.like(activityId: activityId, userId: 'userId'),
          isTrue,
        );
      });

      test('A failure exception should be thrown when unsucessful', () {
        when(
          api.endpointUri(Endpoint.activity,
              pathSegments: [activityId, 'like']),
        ).thenReturn(unsucessfulUri);
        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.errorStatus, 400));

        expect(
          () async => service.like(activityId: activityId, userId: 'userId'),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('unlike', () {
      const request = ActivityLikeRequest(userId: 'userId');

      test('Value [true] should be return when successful', () async {
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'unlike'],
          ),
        ).thenReturn(successUri);
        when(
          client.delete(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.okStatus, 200));

        expect(
          await service.unlike(activityId: activityId, userId: 'userId'),
          isTrue,
        );
      });

      test('A failure exception should be thrown when unsucessful', () {
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'unlike'],
          ),
        ).thenReturn(unsucessfulUri);
        when(
          client.delete(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(activity.errorStatus, 400));

        expect(
          () async => service.unlike(activityId: activityId, userId: 'userId'),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('archive/delete', () {
      test('Value [true] should be return when successful', () async {
        when(client.delete(successUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.okStatus, 200));

        expect(await service.delete(activityId: activityId), isTrue);
      });

      test('A failure exception should be thrown when unsucessful', () {
        when(api.endpointUri(Endpoint.activity, pathSegments: [activityId]))
            .thenReturn(unsucessfulUri);
        when(client.delete(unsucessfulUri, headers: headers))
            .thenAnswer((_) async => http.Response(activity.errorStatus, 400));

        expect(
          () async => service.delete(activityId: activityId),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('update', () {
      const request = ActivityRequest(userId: 'userId');
      test('Value [true] should be return when successful', () async {
        when(api.endpointUri(Endpoint.activity, pathSegments: [activityId]))
            .thenReturn(successUri);
        when(
          client.put(successUri, headers: headers, body: json.encode(request)),
        ).thenAnswer((_) async => http.Response(activity.okStatus, 200));

        expect(
          await service.update(activityId: activityId, request: request),
          isTrue,
        );
      });

      test('A failure exception should be thrown when unsucessful', () {
        when(api.endpointUri(Endpoint.activity, pathSegments: [activityId]))
            .thenReturn(unsucessfulUri);
        when(
          client.put(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(activity.errorStatus, 400));

        expect(
          () async => service.update(activityId: activityId, request: request),
          throwsA(isA<FailureException>()),
        );
      });
    });
  });
}
