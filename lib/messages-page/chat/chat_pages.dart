import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/MyTextField.dart';
import 'package:lft/community-pages/components/chat_bubble.dart';
import 'package:lft/messages-page/chat/chat_services.dart';
import 'package:lft/mmodel/message.dart';

class ChatPage extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUsername,
    required this.receiverUserID,
  });

  @override 
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

//  @override 
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(widget.receiverUsername),   
//         ),
//         body: Column(
//         children: [
//           // messages
//           Expanded(
//             child: _buildMessageList(),
//           ),

//           // user input
//           _buildMessageInput(),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  // Replace with user's profile picture URL
                  'https://placehold.it/100x100'),
            ),
            const SizedBox(width: 10.0),
            Text(widget.receiverUsername),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Chat message list (using StreamBuilder)
          _buildMessageList(),
          // Input field positioned at the bottom
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        _firebaseAuth.currentUser!.uid, widget.receiverUserID), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs
          .map((document) => _buildMessageItem(document))
          .toList(),
        );

      },
    );
  }

  // // build message item
  // Widget _buildMessageItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  //   // align the messages to the right if the sender is the current user, otherwise to the left
  //   var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //     ? Alignment.centerRight
  //     : Alignment.centerLeft;

  //     return Container( 
  //       alignment: alignment,
  //       child: Padding(
  //         padding: const EdgeInsets.all(5.0),
  //         child: Column (
  //           crossAxisAlignment: 
  //             (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //               ? CrossAxisAlignment.end
  //               : CrossAxisAlignment.start,
  //           mainAxisAlignment: 
  //             (data['senderId'] == _firebaseAuth.currentUser!.uid)
  //               ? MainAxisAlignment.end
  //               : MainAxisAlignment.start,
  //           children: [
  //             Text(data['senderEmail']),
  //             const SizedBox(height: 5),
  //             ChatBubble(message: data['message']),
  //           ],
  //         ),
  //       ),
  //     );
  // }

    Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
    final Color? bubbleColor = isCurrentUser ? Color.fromRGBO(124, 111, 233, 1) : Colors.grey[200];
    final Color textColor = isCurrentUser ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display sender avatar only if it's not the current user
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: NetworkImage(
                  // Replace with user's profile picture URL
                  'https://placehold.it/30x30'),
            ),
          SizedBox(width: !isCurrentUser ? 8.0 : 0.0),
          Container(
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              data['message'],
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  // // build message input
  // Widget _buildMessageInput() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
  //     child: Row(
  //       children: [
  //         // textfield
  //         Expanded(
  //           child: MyTextField(
  //             controller: _messageController,
  //             hintText: 'Enter Message',
  //             obscureText: false,
  //           ),
  //         ),

  //         // send button
  //         IconButton(
  //           onPressed: sendMessage, 
  //           icon: const Icon(
  //           Icons.arrow_upward,
  //           size: 40,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Message...',
              obscureText: false,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color.fromRGBO(124, 111, 233, 1)),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

}