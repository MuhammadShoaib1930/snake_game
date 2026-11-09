import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'snake_event.dart';
part 'snake_state.dart';

class SnakeBloc extends Bloc<SnakeEvent, SnakeState> {
  final Random random = Random();
  Timer? timer;
  SnakeBloc() : super(SnakeState(gridSize: 10)) {
    on<StartGame>(_startGame);
    on<ChangeDarection>(_changeDarection);
    on<MoveSnake>(_moveSnake);
    on<EndGame>(_endGame);
  }
  String randomDarection() {
    List<String> darections = ["left", "write", "down", "up"];
    return darections[random.nextInt(darections.length)];
  }

  FutureOr<void> _startGame(StartGame event, Emitter<SnakeState> emit) {
    timer?.cancel();
    int initalSnakePosition = random.nextInt((state.gridSize * state.gridSize - 3)) + 3;
    final initialSnake = [initalSnakePosition, initalSnakePosition - 1, initalSnakePosition - 2];

    emit(
      state.copyWith(
        snake: initialSnake,
        darection: randomDarection(),
        score: 0,
        isGameOver: false,
        food: generateFood(initialSnake),
      ),
    );

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) => add(MoveSnake()));
  }

  void _changeDarection(ChangeDarection event, Emitter<SnakeState> emit) {
    // print("Button pressed: ${event.newDarection}");
    // print("Current direction: ${state.darection}");

    if (state.isGameOver) return;

    if ((state.darection == 'right' && event.newDarection == 'left') ||
        (state.darection == 'left' && event.newDarection == 'right') ||
        (state.darection == 'up' && event.newDarection == 'down') ||
        (state.darection == 'down' && event.newDarection == 'up')) {
      // print("Opposite direction rejected");
      return;
    }

    emit(state.copyWith(darection: event.newDarection));

    // print("New direction: ${event.newDarection}");
  }

  void _moveSnake(MoveSnake event, Emitter<SnakeState> emit) {
    if (state.isGameOver) return;

    int head = state.snake.first;
    int gridSize = state.gridSize;

    switch (state.darection) {
      case 'right':
        head++;
        break;
      case 'left':
        head--;
        break;
      case 'up':
        head -= gridSize;
        break;
      case 'down':
        head += gridSize;
        break;
    }

    if (head % gridSize == 0 && state.darection == "right") {
      head -= gridSize;
    } else if (head < 0 && state.darection == 'up') {
      head = gridSize * gridSize - (gridSize - state.snake[1]);
    } else if (head > gridSize * gridSize && state.darection == "down") {
      head = head % 10;
    } else if (state.snake[0] % gridSize == 0 && state.darection == 'left') {
      // print("head = $head % grid = $gridSize ${head % gridSize}== 0");
      head += gridSize;
    }

    bool ateFood = head == state.food;

    if (state.snake.take(ateFood ? state.snake.length : state.snake.length - 1).contains(head)) {
      add(EndGame());
      return;
    }

    if (ateFood) {
      final newSnake = [head, ...state.snake];

      if (newSnake.length == gridSize * gridSize) {
        emit(state.copyWith(snake: newSnake, score: state.score + 1, isGameOver: true));
        timer?.cancel();
        return;
      }

      emit(state.copyWith(snake: newSnake, score: state.score + 1, food: generateFood(newSnake)));
    } else {
      emit(state.copyWith(snake: [head, ...state.snake.take(state.snake.length - 1)]));
    }
  }

  FutureOr<void> _endGame(EndGame event, Emitter<SnakeState> emit) {
    timer?.cancel();
    emit(state.copyWith(isGameOver: true));
  }

  int generateFood(List<int> snake) {
    final totalCells = state.gridSize * state.gridSize;

    if (snake.length >= totalCells) {
      return -1;
    }

    int food;

    do {
      food = random.nextInt(totalCells);
    } while (snake.contains(food));

    return food;
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
