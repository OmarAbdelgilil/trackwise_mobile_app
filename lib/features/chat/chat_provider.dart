import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/chat/domain/models/chat_message.dart';



@injectable
class ChatDetailsNotifier
    extends StateNotifier<Map<String, List<ChatMessage>>> {
  
  ChatDetailsNotifier() : super({});
  void fromStreamBuilder(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, String myEmail) {
    final Map<String, List<ChatMessage>> newState = {};
    for (final doc in docs) {
      final participants = doc.data()['participants'] as List<dynamic>;
      final friendEmail = participants.firstWhere((element) => element != myEmail, orElse: () => null);
      if (friendEmail == null) continue;
      if (doc.data().containsKey('chat')) {
        final chatList = doc.data()['chat'] as List<dynamic>;
        final tempList = chatList.map((message) => ChatMessage.fromJson(message)).toList();
        tempList.sort((b, a) {
        final aTimestamp = a.createdAt;
        final bTimestamp = b.createdAt;
        return bTimestamp.compareTo(aTimestamp);
      });
        newState[friendEmail] = tempList;
      } else {
        newState[friendEmail] = [];
      }
    }
    Future.microtask(() => state = newState);
  }
}

final chatDetailsProvider =
    StateNotifierProvider<ChatDetailsNotifier, Map<String, List<ChatMessage>>>(
        (ref) => getIt<ChatDetailsNotifier>());
