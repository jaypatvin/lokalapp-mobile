import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lokalapp/models/activity_feed_comment.dart';
import 'package:lokalapp/models/failure_exception.dart';
import 'package:lokalapp/models/lokal_images.dart';
import 'package:lokalapp/models/post_requests/activities/comment.like.request.dart';
import 'package:lokalapp/models/post_requests/activities/comment.request.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/client/lokal_http_client.dart';
import 'package:lokalapp/services/api/comment_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'comment_api_service_test.mocks.dart';
import 'responses/comment_api_service.responses.dart' as response;

@GenerateMocks([API, LokalHttpClient])
void main() {
  group('[CommentAPIService]', () {
    final api = MockAPI();
    final client = MockLokalHttpClient();
    final service = CommentsAPIService(api, client: client);

    final successUri = Uri.parse('https://success.example.com');
    final unsucessfulUri = Uri.parse('https://unsuccessful.example.com');
    const headers = <String, String>{'idToken': 'valid'};

    group('getByID', () {
      const activityId = 'activityId';
      const commentId = 'commentId';
      test('An [ActivityFeedComment] should be returned when successful',
          () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successResponse, 200),
        );

        expect(
          await service.getById(activityId: activityId, commentId: commentId),
          isA<ActivityFeedComment>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(unsucessfulUri);

        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.error404, 404),
        );

        expect(
          () async =>
              service.getById(activityId: activityId, commentId: commentId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeyResponse, 200),
        );

        expect(
          () async =>
              service.getById(activityId: activityId, commentId: commentId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getActivityComments', () {
      const activityId = 'activityId';

      test('A [List<ActivityFeedComment>] should be returned when successful',
          () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successListResponse, 200),
        );

        expect(
          await service.getActivityComments(activityId: activityId),
          isA<List<ActivityFeedComment>>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(unsucessfulUri);

        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.error404, 404),
        );

        expect(
          () async => service.getActivityComments(activityId: activityId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeyListResponse, 200),
        );

        expect(
          () async => service.getActivityComments(activityId: activityId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('getUserComments', () {
      const userId = 'activityId';

      test('A [List<ActivityFeedComment>] should be returned when successful',
          () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.user,
            pathSegments: [userId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.successListResponse, 200),
        );

        expect(
          await service.getUserComments(userId: userId),
          isA<List<ActivityFeedComment>>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.user,
            pathSegments: [userId, 'comments'],
          ),
        ).thenReturn(unsucessfulUri);

        when(client.get(unsucessfulUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.error404, 404),
        );

        expect(
          () async => service.getUserComments(userId: userId),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.user,
            pathSegments: [userId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(client.get(successUri, headers: headers)).thenAnswer(
          (_) async => http.Response(response.missingKeyListResponse, 200),
        );

        expect(
          () async => service.getUserComments(userId: userId),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('create', () {
      const activityId = 'activityId';
      const request = CommentRequest(
        userId: 'userId',
        message: 'hello',
        images: [LokalImages(url: 'url', order: 0)],
      );

      test('An [ActivityFeedComment] should be returned when successful',
          () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer(
          (_) async => http.Response(response.successResponse, 200),
        );

        expect(
          await service.create(activityId: activityId, request: request),
          isA<ActivityFeedComment>(),
        );
      });

      test('A [FailureException] should be thrown when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(unsucessfulUri);

        when(
          client.post(
            unsucessfulUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer(
          (_) async => http.Response(response.errorCreate, 400),
        );

        expect(
          () async => service.create(activityId: activityId, request: request),
          throwsA(isA<FailureException>()),
        );
      });

      test(
          'A [MissingRequiredKeysException] should be thrown when payload is '
          'missing a required Key (i.e., ID)', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments'],
          ),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer(
          (_) async => http.Response(response.missingKeyResponse, 200),
        );

        expect(
          () async => service.create(activityId: activityId, request: request),
          throwsA(isA<MissingRequiredKeysException>()),
        );
      });
    });

    group('like', () {
      const activityId = 'activityId';
      const commentId = 'commentId';
      const userId = 'userId';
      const request = CommentLikeRequest(userId: userId);

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'like'],
          ),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.like(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'like'],
          ),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.like(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'like'],
          ),
        ).thenReturn(successUri);

        when(
          client.post(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.like(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('update', () {
      const activityId = 'activityId';
      const commentId = 'commentId';
      const message = 'hi';

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'message': message}),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.update(
            activityId: activityId,
            commentId: commentId,
            message: message,
          ),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'message': message}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.update(
            activityId: activityId,
            commentId: commentId,
            message: message,
          ),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.put(
            successUri,
            headers: headers,
            body: json.encode({'message': message}),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.update(
            activityId: activityId,
            commentId: commentId,
            message: message,
          ),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('delete', () {
      const activityId = 'activityId';
      const commentId = 'commentId';
      test('A value of [true] should be returned when successful', () async {
        when(api.authHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.delete(activityId: activityId, commentId: commentId),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.delete(activityId: activityId, commentId: commentId),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async =>
              service.delete(activityId: activityId, commentId: commentId),
          throwsA(isA<FailureException>()),
        );
      });
    });

    group('unlike', () {
      const activityId = 'activityId';
      const commentId = 'commentId';
      const userId = 'userId';
      const request = CommentLikeRequest(userId: userId);

      test('A value of [true] should be returned when successful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'unlike'],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
            body: json.encode(request.toJson()),
          ),
        ).thenAnswer((_) async => http.Response(response.okStatus, 200));

        expect(
          await service.unlike(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          isTrue,
        );
      });

      test('A value of [false] should be returned when unsuccessful', () async {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'unlike'],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 200));

        expect(
          await service.unlike(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          isFalse,
        );
      });

      test(
          'A [FailureException] should be thrown when response status is not '
          '200', () {
        when(api.withBodyHeader()).thenReturn(headers);
        when(
          api.endpointUri(
            Endpoint.activity,
            pathSegments: [activityId, 'comments', commentId, 'unlike'],
          ),
        ).thenReturn(successUri);

        when(
          client.delete(
            successUri,
            headers: headers,
            body: json.encode(request),
          ),
        ).thenAnswer((_) async => http.Response(response.errorStatus, 400));

        expect(
          () async => service.unlike(
            activityId: activityId,
            commentId: commentId,
            userId: userId,
          ),
          throwsA(isA<FailureException>()),
        );
      });
    });
  });
}
