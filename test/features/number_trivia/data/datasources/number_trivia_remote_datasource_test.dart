import '../../../../fixtures/fixture_reader.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientResponse(String response, int statusCode) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(response, statusCode));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being
       the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientResponse(fixture('trivia.json'), HttpStatus.ok);
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientResponse(fixture('trivia.json'), HttpStatus.ok);
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientResponse(
            'Something went wrong.', HttpStatus.notFound);
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with random being
       the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientResponse(fixture('trivia.json'), HttpStatus.ok);
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get('http://numbersapi.com/random', headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientResponse(fixture('trivia.json'), HttpStatus.ok);
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientResponse(
            'Something went wrong.', HttpStatus.notFound);
        // act
        final call = dataSource.getRandomNumberTrivia();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
