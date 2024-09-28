import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({super.key, required this.message,
    required this.alignment, required this.isCurrentUser
  });
  final String message;
  final AlignmentGeometry alignment;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrnWidth = MediaQuery.sizeOf(context).width;
    const borderRadius = 13.0;
    final fontSize = theme.textTheme.bodyMedium!.fontSize!;

    return Container(
        constraints: message.length * fontSize > scrnWidth * 0.65 ? BoxConstraints(
            maxWidth: scrnWidth * 0.65
        ) :
        const BoxConstraints(
            minWidth: 0
        )
        ,
        alignment: alignment,
        margin: const EdgeInsets.only(top: 8, bottom: 1.5, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
            color: isCurrentUser ? theme.colorScheme.primary : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: IntrinsicWidth(
          child: Text(message,
              style: theme.textTheme.bodyLarge,
              textAlign: isCurrentUser ? TextAlign.end : TextAlign.start
          ),
        )
    );
  }
}