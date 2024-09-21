import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soft_llama/auth/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(
        //     seedColor: Colors.yellow,
        //   ),
        //   useMaterial3: true,
        //   brightness: Brightness.light,
        //   appBarTheme: const AppBarTheme(
        //     backgroundColor: Colors.yellow,
        //     elevation: 0,
        //   ),
        //   scaffoldBackgroundColor: Colors.white,
        //   iconTheme: const IconThemeData(
        //     color: Colors.yellow,
        //   ),
        //   buttonTheme:const ButtonThemeData(
        //     buttonColor: Colors.yellow,
        //     textTheme: ButtonTextTheme.primary,
        //   ),
        // ),

        home: AuthGate(idx: 0)
    );
  }
}
