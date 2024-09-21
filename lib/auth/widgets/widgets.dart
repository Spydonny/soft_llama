import 'package:flutter/material.dart';

class DefaultAlert extends StatelessWidget {
  const DefaultAlert({super.key,
    required this.label, required this.content
  });
  final String label;
  final String content;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(label,
        style: theme.textTheme.bodyLarge,
      ),
      content: Text(
        content,
        style: theme.textTheme.bodyMedium,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ок')
        )
      ],
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({super.key, required this.controller,
    required this.label, required this.isPassword
  });
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = 5.0;
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: SizedBox(
        child: TextField(
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: const  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)
              ),
              label: Text(label, style: theme.textTheme.labelSmall,)
          ),
        ),
      ),
    );
  }
}

