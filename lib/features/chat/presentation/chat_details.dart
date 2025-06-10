import 'package:flutter/material.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/widgets/chat.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/widgets/new_message.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key, required this.email});
  final String email;

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
      ),
      body: Column(children: [
        Expanded(child: Chat(email: widget.email,)),
        NewMessage(email: widget.email)]),
    );
  }
}