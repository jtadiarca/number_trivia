import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/extensions/string_extensions.dart';
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
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(ConcreteNumberTriviaEvent('-1'));
      },
    );
  });
}
