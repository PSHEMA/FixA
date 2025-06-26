import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/chat_room_model.dart';
import 'package:fix_my_area/models/message_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Send a message
  Future<void> sendMessage(UserModel receiver, String message) async {
    final UserModel currentUser = (await _authService.getUserDetails())!;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
      senderId: currentUser.uid,
      receiverId: receiver.uid,
      text: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUser.uid, receiver.uid];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Add new message to the messages subcollection
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());

    // Update the main chat room document with last message info
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participantIds': ids,
      'participantNames': {
        currentUser.uid: currentUser.name,
        receiver.uid: receiver.name,
      },
      'lastMessage': message,
      'lastMessageTimestamp': timestamp,
    }, SetOptions(merge: true));
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

  // Get all chat rooms for the current user
  Stream<List<ChatRoomModel>> getChatRooms() {
    final String currentUserId = _authService.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatRoomModel.fromFirestore(doc)).toList());
  }
}
