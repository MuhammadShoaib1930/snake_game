import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snkgame/blocs/bloc/snake_bloc.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  @override
  void initState() {
    super.initState();
    context.read<SnakeBloc>().add(StartGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Snake game"), centerTitle: true),
      body: BlocBuilder<SnakeBloc, SnakeState>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Center(child: Text("Score: ${state.score}")),
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state.gridSize,
                    ),
                    itemBuilder: (context, index) {
                      bool isSnakePart = state.snake.contains(index);
                      bool isFood = index == state.food;
                      return Container(
                        margin: EdgeInsets.all(1),
                        color: const Color.fromARGB(255, 86, 84, 84),
                        child: (isSnakePart)
                            ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(

                                  decoration: BoxDecoration(
                                    color: Colors.blue,

                                    borderRadius: BorderRadius.circular(40),

                                  ),
                                ),
                            )
                            : (isFood)
                            ? Icon(Icons.add_moderator, color:const Color.fromARGB(255, 2, 230, 9), size: 40)
                            : null,
                      );
                    },
                    itemCount: state.gridSize * state.gridSize,
                  ),
                ),
                state.isGameOver
                    ? Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "GameOver",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<SnakeBloc>().add(StartGame());
                              },
                              child: Text(
                                "Restart",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 230,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<SnakeBloc>().add(ChangeDarection("up"));
                              },
                              child: Icon(Icons.arrow_upward),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<SnakeBloc>().add(ChangeDarection("left"));
                                  },
                                  child: Icon(Icons.arrow_back),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<SnakeBloc>().add(ChangeDarection("right"));
                                  },
                                  child: Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<SnakeBloc>().add(ChangeDarection("down"));
                              },
                              child: Icon(Icons.arrow_downward),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
