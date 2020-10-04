import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure_messages.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockConcreteNumberTrivia extends Mock implements ConcreteNumberTrivia {}

class MockRandomNumberTrivia extends Mock implements RandomNumberTrivia {}

void main() {
  NumberTriviaBloc bloc;
  MockConcreteNumberTrivia mockConcreteNumberTrivia;
  MockRandomNumberTrivia mockRandomNumberTrivia;

  setUp(() {
    mockConcreteNumberTrivia = MockConcreteNumberTrivia();
    mockRandomNumberTrivia = MockRandomNumberTrivia();

    bloc = NumberTriviaBloc(
        concreteNumberTrivia: mockConcreteNumberTrivia,
        randomNumberTrivia: mockRandomNumberTrivia);
  });

  test('initialState should be Empty', () {
    //assert
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('ConcreteNumberTriviaEvent', () {
    final String tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        // assert later
        final expected = [
          NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(ConcreteNumberTriviaEvent('-1'));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(ConcreteNumberTriviaEvent(tNumberString));
        await untilCalled(mockConcreteNumberTrivia(any));
        // assert
        verify(mockConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten sucessfully',
      () async {
        // arrange
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should emit [NumberTriviaLoading, Error] when getting data fails',
      () async {
        // arrange
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should emit [NumberTriviaLoading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });

  group('RandomNumberTriviaEvent', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(RandomNumberTriviaEvent());
        await untilCalled(mockRandomNumberTrivia(any));
        // assert
        verify(mockRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [NumberTriviaLoading, NumberTriviaLoaded] when data is gotten sucessfully',
      () async {
        // arrange
        when(mockRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(RandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [NumberTriviaLoading, Error] when getting data fails',
      () async {
        // arrange
        when(mockRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(RandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [NumberTriviaLoading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(RandomNumberTriviaEvent());
      },
    );
  });
}
