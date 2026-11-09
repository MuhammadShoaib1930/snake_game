
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SnakeGame(),
  ));
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int gridSize = 20;
  final Random random = Random();

  List<int> snake = [30, 25, 10];
  int food = 100;
  String diraction = 'right';
  int score = 0;
  bool gameOver = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();

    setState(() {
      snake = [42, 41, 40];
      diraction = 'right';
      score = 0;
      gameOver = false;
      generateFood();
    });

    timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (timer) => moveSnake(),
    );
  }

  void generateFood() {
    do {
      food = random.nextInt(gridSize * gridSize);
    } while (snake.contains(food));
  }

  void moveSnake() {
    if (gameOver) return;

    setState(() {
      int head = snake.first;

      switch (diraction) {
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

      if (head < 0 ||
          head >= gridSize * gridSize ||
          (diraction == 'right' && head % gridSize == 0) ||
          (diraction == 'left' && head % gridSize == gridSize - 1)) {
        endGame();
        return;
      }

      bool ateFood = head == food;

      if (snake.take(ateFood ? snake.length : snake.length - 1)
          .contains(head)) {
        endGame();
        return;
      }

      snake.insert(0, head);

      if (ateFood) {
        score++;
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void endGame() {
    timer?.cancel();
    gameOver = true;
  }

  void changediraction(String newdiraction) {
    if ((diraction == 'right' && newdiraction == 'left') ||
        (diraction == 'left' && newdiraction == 'right') ||
        (diraction == 'up' && newdiraction == 'down') ||
        (diraction == 'down' && newdiraction == 'up')) {
      return;
    }

    diraction = newdiraction;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Snake Game'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),

          const SizedBox(height: 20),

          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                bool isSnake = snake.contains(index);
                bool isFood = index == food;

                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSnake
                        ? Colors.green
                        : isFood
                            ? Colors.red
                            : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          if (gameOver)
            Column(
              children: [
                const Text(
                  'GAME OVER!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 28,
                  ),
                ),
                ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Restart'),
                ),
              ],
            ),

          // diraction controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => changediraction('left'),
                icon: const Icon(Icons.arrow_left),
                color: Colors.white,
                iconSize: 45,
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => changediraction('up'),
                    icon: const Icon(Icons.arrow_upward),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () => changediraction('down'),
                    icon: const Icon(Icons.arrow_downward),
                    color: Colors.white,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => changediraction('right'),
                icon: const Icon(Icons.arrow_right),
                color: Colors.white,
                iconSize: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
