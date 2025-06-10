import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/core/provider/user_provider.dart';
import 'package:track_wise_mobile_app/features/chat/chat_provider.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/viewmodel/chat_viewmodel.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/widgets/message_bubble.dart';

class Chat extends ConsumerStatefulWidget
{
  const Chat({super.key, required this.email});
  final String email;

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  
  @override
  Widget build(BuildContext context) {
      final messagesWatch = ref.watch(chatDetailsProvider);
      final messages = messagesWatch[widget.email] ?? [];
      messages.sort((a, b) {
        final aTimestamp = a.createdAt;
        final bTimestamp = b.createdAt;
        return bTimestamp.compareTo(aTimestamp);
      });
      return Padding(
        padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
        child: ListView.builder(itemCount: messages.length,reverse: true ,itemBuilder: (context, index) {
          final nextChatMessage = index+1< messages.length ?  messages[index+1]: null;
          final currentMessageUserId = messages[index].senderId;
          final nextMessageUserId = nextChatMessage?.senderId;
          final nextUserIsSame = nextMessageUserId == currentMessageUserId;
          final isMe = widget.email != messages[index].senderId;
          if(nextUserIsSame)
          {
            return MessageBubble.next(message: messages[index].message, isMe: isMe);
          }else{
            late String username;

            try {
              if (isMe) {
              username = ref.read(userProvider)!.firstName;
              } else {
              username = ref.read(chatViewmodelProvider.notifier).friends!
                .firstWhere((element) => element.email == messages[index].senderId)
                .name.split(' ')[0];
              }
            } catch (e) {
              username = messages[index].senderId.split('@')[0];
            }

            
            return MessageBubble.first(userImage:  null, username:  username, message: messages[index].message, isMe: isMe);
          }

        },),
      );
    
    
    
  }
}