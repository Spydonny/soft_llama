import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_llama/messages/widget/message_container.dart';

import '../services.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
    final _authService = FirebaseAuth.instance;
    final _chatService = ChatService();
    final TextEditingController _controller = TextEditingController();
    final double borderRadius = 12;


    void sendMessage() async {
      if (_controller.text.isNotEmpty) {
        final text = _controller.text;
        _controller.clear();
        await _chatService.sendMessage(text);
      }
    }


    @override
    Widget build(BuildContext context) {
      final mediaQuery = MediaQuery.sizeOf(context);
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.sizeOf(context).height*0.04,),
            Expanded(
                child: _buildMessageList(context)
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 7.0),
          child:  Container(
          height: mediaQuery.height * 0.06,
          width: mediaQuery.width,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Flexible(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                                hintText: 'Отправьте отзыв',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent)
                                )
                            ),
                          )
                      )
                  )
              ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: mediaQuery.width * 0.09,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white70,),
                onPressed: () => sendMessage(),
              ),
            ),
          )

            ],
          ),
        ),
        ),
      );
    }

    Widget _buildMessageList(BuildContext context) {
      String senderID = _authService.currentUser!.uid;
      return StreamBuilder(
          stream: _chatService.getMessages(senderID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Ошибка'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Загрузка...'),
              );
            }
            return ListView(
                children: snapshot.data!.docs.map((doc) =>
                    _buildMessageItem(doc, context))
                    .toList()
            );
          }
      );
    }

    Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      final timestamp = data['timestamp'];

      final int seconds = timestamp.seconds;
      final int nanoseconds = timestamp.nanoseconds;

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
      dateTime = dateTime.add(Duration(milliseconds: nanoseconds ~/ 1000000));
      DateFormat formatter = DateFormat('HH:mm MM-dd');
      String formattedTime = formatter.format(dateTime);

      final currentUser = _authService.currentUser;
      bool isCurrentUser = currentUser!.uid == data['senderID'];
      final AlignmentGeometry alignment = isCurrentUser
          ? Alignment.centerRight
          : Alignment.centerLeft;

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MessageContainer(
                message: data['message'].toString(),
                alignment: alignment,
                isCurrentUser: isCurrentUser,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(formattedTime, style: const TextStyle(
                    fontSize: 10
                ),),
              )
            ],
          )

        ],
      );
    }
  }
