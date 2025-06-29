import 'package:fix_my_area/chat/chat_screen.dart';
import 'package:fix_my_area/models/chat_room_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/chat_service.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();
    final AuthService authService = AuthService();
    final String currentUserId = authService.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: chatService.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Something went wrong.'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No Messages Yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your conversations will appear here.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          
          final chatRooms = snapshot.data!;
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              final otherUserId = room.participantIds.firstWhere((id) => id != currentUserId);
              final otherUserName = room.participantNames[otherUserId] ?? 'Unknown User';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(otherUserName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(room.lastMessage, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    final tempReceiver = UserModel(
                      uid: otherUserId,
                      name: otherUserName,
                      email: '', phone: '', role: '', services: [], bio: '', rate: '', photoUrl: '', district: '', sector: ''
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiver: tempReceiver)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
