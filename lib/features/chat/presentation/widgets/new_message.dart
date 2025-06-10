import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _textFieldController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _textFieldController.clear();
    final myEmail = ref.read(userProvider)!.email;
    final emailList = [myEmail, widget.email];
    emailList.sort((a, b) => a.compareTo(b),);
    FirebaseFirestore.instance.collection('chats').doc("${emailList[0]}||||,,,,${emailList[1]}").set({
      'participants': [myEmail, widget.email],
      'chat': FieldValue.arrayUnion([
        {
          'message': enteredMessage,
          'createdAt': Timestamp.now(),
          'senderId': myEmail,
        },
      ])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(label: Text("Send a message")),
            ),
          ),
          IconButton(onPressed: _submitMessage, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
