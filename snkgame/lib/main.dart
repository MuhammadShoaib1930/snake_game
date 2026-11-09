import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snkgame/blocs/bloc/snake_bloc.dart';
import 'package:snkgame/screens/snake_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(create: (context) => SnakeBloc(), child: SnakeGame()),
    );
  }
}
