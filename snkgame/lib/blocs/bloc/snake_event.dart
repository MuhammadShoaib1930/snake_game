part of 'snake_bloc.dart';

sealed class SnakeEvent extends Equatable {
  const SnakeEvent();
  @override
  List<Object> get props => [];
}
class StartGame extends SnakeEvent{}

/// requried new darection for move
class ChangeDarection extends SnakeEvent {
  final String newDarection;
  const ChangeDarection(this.newDarection);
}
class EndGame extends SnakeEvent{}
class MoveSnake extends SnakeEvent {}
