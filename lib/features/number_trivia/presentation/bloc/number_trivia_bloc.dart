import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/concrete_number_trivia.dart';
import '../../domain/usecases/random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a postive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final ConcreteNumberTrivia concreteNumberTrivia;
  final RandomNumberTrivia randomNumberTrivia;

  NumberTriviaBloc(
      {@required this.concreteNumberTrivia, @required this.randomNumberTrivia})
      : assert(concreteNumberTrivia != null),
        assert(randomNumberTrivia != null),
        super(NumberTriviaInitial());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is ConcreteNumberTriviaEvent) {
      final inputEither = event.numberString.toUnsignedInt();

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) => throw UnimplementedError(),
      );
    }
  }
}
