import 'package:flutter/material.dart';
import 'auth_gate.dart';
import '../services.dart';
// import 'signup_screen.dart';
import 'widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        emailController.text, passwordController.text,);
    } catch (e) {
      String message = '';
      switch (e.toString()) {
        case 'Exception: invalid-email':
          setState(() {
            message = 'Такого email у нас нет';
          });
        case 'Exception: invalid-credential':
          setState(() {
            message = 'Вы ввели неправильный пароль';
          });
        case 'Exception: missing-password':
          setState(() {
            message = 'Вы должны написать пароль';
          });
        default:
          setState(() {
            message = 'Попробуйте позже';
          });
      }
      showDialog(
          context: context,
          builder: (context) =>
              DefaultAlert(
                label: 'Ошибка',
                content: message,
              )
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double scrnWidth = MediaQuery
        .sizeOf(context)
        .width;
    final double scrnHeight = MediaQuery
        .sizeOf(context)
        .height;

    return Scaffold(
      body: Center(
        child: Container(
          height: scrnHeight * 0.55,
          width: scrnWidth * 0.95,
          padding: EdgeInsets.symmetric(horizontal: scrnWidth * 0.08),
          decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.abc_sharp, color: theme.colorScheme.primary,
                  size: scrnHeight * 0.12),
              Text('Снова добро пожаловать пользователь',
                style: theme.textTheme.bodyMedium,
              ),
              TextFieldContainer(
                controller: emailController,
                label: 'Ваш email',
                isPassword: false,),
              TextFieldContainer(
                controller: passwordController,
                label: 'Ваш пароль',
                isPassword: true,),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(
                        Size(scrnWidth * 0.45, scrnHeight * 0.08)),
                    maximumSize: WidgetStateProperty.all<Size>(
                        Size(scrnWidth * 0.55, scrnHeight * 0.08))
                ),
                onPressed: () => login(context),
                child: Text('Войти',
                    style: theme.textTheme.bodyLarge
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('У вас нет аккаунта?   ',
                    style: theme.textTheme.labelSmall,
                  ), TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const AuthGate(idx: 1,)
                          ),
                        ),
                    child: Text('Зарегестрируйтесь',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2,)
            ],
          ),
        ),
      ),
    );
  }
}
