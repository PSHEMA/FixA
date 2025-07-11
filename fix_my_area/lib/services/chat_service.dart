import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/chat_room_model.dart';
import 'package:fix_my_area/models/message_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/notification_service.dart';
import 'package:fix_my_area/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  String getChatRoomId(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendTextMessage(UserModel receiver, String message) async {
    final currentUser = (await _authService.getUserDetails())!;
    final Timestamp timestamp = Timestamp.now();
    final chatRoomId = getChatRoomId(currentUser.uid, receiver.uid);

    MessageModel newMessage = MessageModel(
      senderId: currentUser.uid,
      receiverId: receiver.uid,
      text: message,
      timestamp: timestamp,
      type: 'text',
    );

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
    await _updateChatRoom(chatRoomId, currentUser, receiver, message);
    await _notificationService.createNotification(
      userId: receiver.uid,
      title: 'New Message from ${currentUser.name}',
      body: message,
      type: 'chat',
      referenceId: chatRoomId,
    );
  }

  Future<void> sendImageMessage(UserModel receiver, XFile imageFile) async {
    final currentUser = (await _authService.getUserDetails())!;
    final Timestamp timestamp = Timestamp.now();
    final chatRoomId = getChatRoomId(currentUser.uid, receiver.uid);

    final imageUrl = await _storageService.uploadChatImage(imageFile, chatRoomId);

    MessageModel newMessage = MessageModel(
      senderId: currentUser.uid,
      receiverId: receiver.uid,
      text: '',
      timestamp: timestamp,
      type: 'image',
      imageUrl: imageUrl,
    );

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
    await _updateChatRoom(chatRoomId, currentUser, receiver, "📷 Sent an image");
    await _notificationService.createNotification(
      userId: receiver.uid,
      title: 'New Message from ${currentUser.name}',
      body: "Sent you an image.",
      type: 'chat',
      referenceId: chatRoomId,
    );
  }

  Future<void> sendMessage(UserModel receiver, String message) async {
    await sendTextMessage(receiver, message);
  }

  Future<void> _updateChatRoom(String chatRoomId, UserModel currentUser, UserModel receiver, String lastMessage) async {
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participantIds': [currentUser.uid, receiver.uid],
      'participantNames': {
        currentUser.uid: currentUser.name,
        receiver.uid: receiver.name,
      },
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    final chatRoomId = getChatRoomId(userId, otherUserId);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

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