import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/failure_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/concrete_number_trivia.dart';
import '../../domain/usecases/random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

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
          yield NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield NumberTriviaLoading();
          final failureOrTrivia =
              await concreteNumberTrivia(Params(number: integer));

          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is RandomNumberTriviaEvent) {
      yield NumberTriviaLoading();
      final failureOrTrivia = await randomNumberTrivia(NoParams());

      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => NumberTriviaError(message: failure.toMessage()),
      (trivia) => NumberTriviaLoaded(trivia: trivia),
    );
  }
}
