import 'package:flutter/material.dart';
import 'package:soft_llama/auth/services.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 5,),
            const Text('Soft LLaMa'),
            IconButton(
              icon: const Icon(Icons.open_in_new),
                onPressed: AuthService().signOut)
          ],
        )
      ),
      body: const TapGameScreen(),
    );
  }
}
