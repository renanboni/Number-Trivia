
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });
  
  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () {
      final str = '1234';

      final result = inputConverter.stringToUnsignedInt(str);

      expect(result, Right(1234));
    });

    test('should return a Failure when the string is not an integer', () {
      final str = 'abcd';

      final result = inputConverter.stringToUnsignedInt(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer', () {
      final str = '-1234';

      final result = inputConverter.stringToUnsignedInt(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}