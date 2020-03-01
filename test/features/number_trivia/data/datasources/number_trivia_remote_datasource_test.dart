import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(MockHttpClient mockHttpClient) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL
     with number being the endpoint and with application/json header''', () {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the responde code is 200 (success)', () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the responde code is 404 or other', () {
      setUpMockHttpClientFailure404(mockHttpClient);

      expect(() => dataSource.getConcreteNumberTrivia(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL
     with number being the endpoint and with application/json header''', () {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the responde code is 200 (success)', () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the responde code is 404 or other', () {
      setUpMockHttpClientFailure404(mockHttpClient);

      expect(() => dataSource.getRandomNumberTrivia(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

