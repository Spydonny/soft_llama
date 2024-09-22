import 'package:flutter/material.dart';
import 'package:soft_llama/game/tap_game.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        title: const  Center(
          child: Text('Soft LLaMa'),
        ),
      ),
      body: const TapGameScreen(),
    );
  }
}
