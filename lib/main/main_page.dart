import 'package:flutter/material.dart';
import 'package:soft_llama/messages/message_screen.dart';
import 'package:soft_llama/services.dart';
import 'package:soft_llama/game/tap_game.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Widget> screens = [const TapGameScreen(), const MessageScreen()];
  int _sIndex = 0;

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
      body: screens[_sIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.games_outlined),
              label: 'Тапалка',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              label: 'Вопросы к боссу',
            ),
          ],
        currentIndex: _sIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int i) {
          setState(() {
            _sIndex = i;
          });
        },

      ),
    );
  }
}

