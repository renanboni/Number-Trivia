import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';

const SERVER_FAILURE_MESSAGE = 'Server failure';
const CACHE_FAILURE_MESSAGE = 'Cache failure';
const INVALID_INPUT_MESSAGE = 'Invalid input - The number must be positive or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter});

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInt(event.numberString);
      
      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_MESSAGE);
      }, (integer) => throw UnimplementedError());
    }
  }
}
