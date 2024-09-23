import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'services.dart';
import 'widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final gradeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Color? _textColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textColor = Theme
        .of(context)
        .textTheme
        .bodyMedium
        ?.color;
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _textColor = Theme
          .of(context)
          .colorScheme
          .primary;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _textColor = Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.color;
    });
  }



  void signup(BuildContext context) async {
    final auth = AuthService();

    if(passwordController.text == confirmPasswordController.text){
      try{
        await auth.signUpWithEmailPassword(emailController.text, passwordController.text,
          firstnameController.text, lastnameController.text, gradeController.text
        );
      } catch(e) {
        String message = '';
        switch (e.toString()) {
          case 'Exception: email-already-in-use':
            setState(() {
              message = 'Вы уже зарегестрированы';
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
    } else {
      showDialog(
          context: context,
          builder: (context) =>
          const DefaultAlert(
            label: 'Пароли не совподают',
            content: 'Проверте пожалуйста правильность\nнаписания пароля',
          )
      );
      return;
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const AuthGate(idx: 0)
        )
    );
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
          height: scrnHeight * 0.81,
          width: scrnWidth * 0.90,
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
              Text(
                'Создайте аккаунт для\nулучшение качество пребывания в проиложении',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              TextFieldContainer(
                controller: firstnameController, label: 'Ваше имя', isPassword: false,),
              TextFieldContainer(
                controller: lastnameController, label: 'Ваша фамилия', isPassword: false,),
              TextFieldContainer(
                controller: gradeController, label: 'Ваш класс', isPassword: false,),
              TextFieldContainer(
                controller: emailController, label: 'Ваш email', isPassword: false,),
              TextFieldContainer(
                  controller: passwordController, label: 'Ваш пароль', isPassword: true),
              TextFieldContainer(controller: confirmPasswordController,
                label: 'Повторите ваш пароль', isPassword: true,),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(
                        Size(scrnWidth * 0.45, scrnHeight * 0.08)),
                    maximumSize: WidgetStateProperty.all<Size>(
                        Size(scrnWidth * 0.55, scrnHeight * 0.08))
                ),
                onPressed: () => signup(context),
                child: Text('Создать аккаунт',
                    style: theme.textTheme.bodyLarge
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('У вас уже есть аккаунта?   ',
                    style: theme.textTheme.labelSmall,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const AuthGate(idx: 0)
                            )
                        ),
                    child: MouseRegion(
                      onEnter: _onEnter,
                      onExit: _onExit,
                      child:
                      Text('Войти',
                        style: TextStyle(
                            fontSize: theme.textTheme.bodyMedium?.fontSize,
                            color: _textColor
                        ),
                      ),
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
