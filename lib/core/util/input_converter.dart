import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    final maybeInt = int.tryParse(str);
    if (maybeInt == null || maybeInt < 0) {
      return Left(InvalidInputFailure());
    }

    return Right(maybeInt);
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
