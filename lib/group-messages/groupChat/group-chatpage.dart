import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/MyTextField.dart';
import 'package:lft/community-pages/components/chat_bubble.dart';
import 'package:lft/group-messages-page/groupChat/group-chat-services.dart';
import 'package:lft/messages-page/chat/chat_services.dart';
import 'package:lft/mmodel/groups.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;

  const GroupChatPage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final GroupService _groupService = GroupService();
  Stream<Group>? _groupStream;
  Stream<QuerySnapshot>? _messagesStream;

  @override
  void initState() {
    super.initState();
    _groupStream = _groupService.getGroup(widget.groupId);
    _messagesStream = _groupService.getGroupMessages(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Group>(
          stream: _groupStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            final group = snapshot.data!;
            return Text(group.name);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.reversed;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages.elementAt(index).data() as Map<String, dynamic>;
                    return buildMessageBubble(messageData);
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  final message = _messageController.text.trim();
                  if (message.isNotEmpty) {
                    _groupService.sendMessage(widget.groupId, message);
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget to build a message bubble
Widget buildMessageBubble(Map<String, dynamic> messageData) {
  final bool isCurrentUser = messageData['sender'] ==
      FirebaseAuth.instance.currentUser!.uid;
  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue[200] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(messageData['message']),
    ),
  );
}