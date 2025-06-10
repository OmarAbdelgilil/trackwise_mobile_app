import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_wise_mobile_app/features/chat/chat_provider.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/chat_details.dart';
import 'package:track_wise_mobile_app/features/chat/presentation/viewmodel/chat_viewmodel.dart';

class HomeChatScreen extends ConsumerWidget {
  const HomeChatScreen({super.key});
  String formatTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(chatViewmodelProvider);
    final chatDetails = ref.watch(chatDetailsProvider);
    final prov = ref.read(chatViewmodelProvider.notifier);
    if (state is LoadingState || state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ErrorState) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Something went wrong.',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                prov.getFriends();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    if (prov.friends == null || prov.friends!.isEmpty) {
      return const Center(
        child: Text('No friends to show'),
      );
    }
    final sortedFriends = List.of(prov.friends!);
    sortedFriends.sort((a, b) {
      final aChats = chatDetails[a.email] ?? [];
      final bChats = chatDetails[b.email] ?? [];
      
      Timestamp? aLast;
      for (var chat in aChats) {
        if (aLast == null || chat.createdAt.compareTo(aLast) > 0) {
          aLast = chat.createdAt;
        }
      }
      Timestamp? bLast;
      for (var chat in bChats) {
        if (bLast == null || chat.createdAt.compareTo(bLast) > 0) {
          bLast = chat.createdAt;
        }
      }
      if (aLast == null && bLast == null) return 0;
      if (aLast == null) return 1;
      if (bLast == null) return -1;
      return bLast.compareTo(aLast);
    });
    return ListView.builder(
      itemCount: sortedFriends.length,
      itemBuilder: (context, index) {
        final friendEmail = sortedFriends[index].email;
        final chat = chatDetails[friendEmail] ?? [];
        chat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[300],
              child: Text(sortedFriends[index].name[0]),
            ),
            title: Text(sortedFriends[index].name),
            subtitle: Text(
              chat.isEmpty ? '' : chat.last.senderId == friendEmail? '${sortedFriends[index].name.split(' ')[0]}: ${chat.last.message}' : 'You: ${chat.last.message}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
                chat.isEmpty ? '' : formatTimeAgo(chat.last.createdAt)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatDetails(email: friendEmail),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
