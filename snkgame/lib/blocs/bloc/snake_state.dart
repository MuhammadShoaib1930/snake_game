part of 'snake_bloc.dart';

class SnakeState extends Equatable {
  final List<int> snake;
  final int food;
  final bool isGameOver;
  final String darection;
  final int score;
  final int gridSize;
  const SnakeState({
    this.snake = const [42, 41, 40],
    this.food = 50,
    this.isGameOver = false,
    this.darection = "right",
    this.score = 0,
    this.gridSize = 10,
  });
  @override
  List<Object> get props => [snake, food, isGameOver, darection, score, gridSize];

  SnakeState copyWith({
    List<int>? snake,
    int? food,
    bool? isGameOver,
    String? darection,
    int? score,
    int? gridSize,
  }) {
    return SnakeState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      isGameOver: isGameOver ?? this.isGameOver,
      darection: darection ?? this.darection,
      score: score ?? this.score,
      gridSize: gridSize ?? this.gridSize,
    );
  }
}
