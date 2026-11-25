import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  group('ApiClient Experience Tests', () {
    test(
      'getExperiences returns a list of Experience on 200 response',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, '/api/v1/experiences/');
          expect(request.method, 'GET');
          return http.Response(
            jsonEncode([
              {
                'id': 'exp-uuid-1',
                'title': 'BETIS Web Developer',
                'description': 'Building educational web app',
                'category': 'part-time',
                'category_display': 'Part-Time',
                'thumbnail': 'https://example.com/thumb.png',
                'started_at': '2026-09-01T00:00:00Z',
                'ended_at': null,
                'is_ongoing': true,
              },
            ]),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final apiClient = ApiClient(
          client: mockClient,
          baseUrl: 'http://localhost:8000',
        );
        final experiences = await apiClient.getExperiences();

        expect(experiences.length, 1);
        expect(experiences.first.id, 'exp-uuid-1');
        expect(experiences.first.title, 'BETIS Web Developer');
        expect(experiences.first.category, 'part-time');
        expect(experiences.first.categoryDisplay, 'Part-Time');
        expect(experiences.first.isOngoing, true);
      },
    );

    test('createExperience sends Token authorization header and returns Experience', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/experiences/');
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Token secret-token-123');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'New Internship');
        expect(body['category'], 'internship');

        return http.Response(
          jsonEncode({
            'id': 'created-uuid-2',
            'title': body['title'],
            'description': body['description'],
            'category': body['category'],
            'category_display': 'Internship',
            'thumbnail': body['thumbnail'],
            'started_at': '2026-11-25T10:00:00Z',
            'ended_at': null,
            'is_ongoing': true,
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final apiClient = ApiClient(
        client: mockClient,
        baseUrl: 'http://localhost:8000',
      );
      const newExp = Experience(
        title: 'New Internship',
        description: 'Working as intern',
        category: 'internship',
      );

      final result = await apiClient.createExperience(
        newExp,
        token: 'secret-token-123',
      );

      expect(result.id, 'created-uuid-2');
      expect(result.title, 'New Internship');
      expect(result.category, 'internship');
    });

    test(
      'deleteExperience sends DELETE with Token and succeeds on 204',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.url.path, '/api/v1/experiences/exp-uuid-1/');
          expect(request.method, 'DELETE');
          expect(request.headers['Authorization'], 'Token test-token');
          return http.Response('', 204);
        });

        final apiClient = ApiClient(
          client: mockClient,
          baseUrl: 'http://localhost:8000',
        );
        await expectLater(
          apiClient.deleteExperience('exp-uuid-1', token: 'test-token'),
          completes,
        );
      },
    );

    test('throws ApiException on non-2xx status code', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid credentials', 401);
      });

      final apiClient = ApiClient(
        client: mockClient,
        baseUrl: 'http://localhost:8000',
      );

      expect(
        () => apiClient.getExperiences(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', 'Invalid credentials'),
        ),
      );
    });
  });
}
