import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/extensions/string_extensions.dart';

void main() {
  group('toUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // act
        final result = '123'.toUnsignedInt();
        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string is not an integer',
      () async {
        // act
        final result = 'abc'.toUnsignedInt();
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string is a negative integer',
      () async {
        // act
        final result = '-123'.toUnsignedInt();
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
