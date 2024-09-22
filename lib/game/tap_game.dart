import 'package:flutter/material.dart';

class TapGameScreen extends StatefulWidget {
  const TapGameScreen({super.key});

  @override
  State<TapGameScreen> createState() => _TapGameScreenState();
}

class _TapGameScreenState extends State<TapGameScreen> {
  int score = 0;
  bool gameStarted = false;
  double targetX = 100;
  double targetY = 100;

  void startGame() {
    setState(() {
      score = 0;
      gameStarted = true;
      _moveTarget();
    });
  }

  void _moveTarget() {
    setState(() {
      targetX = (100 + (300 - 100) * (0.1 + 0.8 * (DateTime.now().millisecond / 1000)));
      targetY = (100 + (400 - 100) * (0.1 + 0.8 * (DateTime.now().second / 60)));
    });
  }

  void onTap() {
    if (!gameStarted) return;
    setState(() {
      score++;
      _moveTarget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Game'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.white,
              child: Center(
                child: gameStarted
                    ? Stack(
                  children: [
                    Positioned(
                      left: targetX,
                      top: targetY,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: startGame,
                  child: const Text("Start Game"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
