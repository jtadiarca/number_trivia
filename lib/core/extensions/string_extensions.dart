import 'package:dartz/dartz.dart';

import '../error/failures.dart';

extension StringConversion on String {
  Either<Failure, int> toUnsignedInt() {
    final maybeInt = int.tryParse(this);
    if (maybeInt == null || maybeInt < 0) {
      return Left(InvalidInputFailure());
    }

    return Right(maybeInt);
  }
}
