import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/chat/chat_provider.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/chat_login.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/home_chat_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(userProvider);
    return prov == null? const ChatLoginScreen() :
    StreamBuilder(stream: FirebaseFirestore.instance.collection('chats').where('participants', arrayContains: prov.email).snapshots(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          else
          {
            if(snapshot.data != null)
            {
              ref.read(chatDetailsProvider.notifier).fromStreamBuilder(snapshot.data!.docs, prov.email);
            }
            
            return const HomeChatScreen();
          }
          
    },);
  }
}