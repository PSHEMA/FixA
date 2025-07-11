import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/chat_service.dart';
import 'package:fix_my_area/services/storage_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;
  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  void _sendTextMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendTextMessage(widget.receiver, _messageController.text);
      _messageController.clear();
    }
  }

  void _sendImageMessage() async {
    final file = await _storageService.pickImage();
    if (file != null) {
      await _chatService.sendImageMessage(widget.receiver, file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver.name)),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(_authService.currentUser!.uid, widget.receiver.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _authService.currentUser!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var messageType = data['type'] ?? 'text';

    return Container(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isCurrentUser ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: messageType == 'image'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(data['imageUrl'], width: 200),
              )
            : Text(data['text'], style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _sendImageMessage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendTextMessage,
          )
        ],
      ),
    );
  }
}
