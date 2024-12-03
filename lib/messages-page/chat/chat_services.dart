import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/mmodel/message.dart';
import 'package:lft/messages-page/messages.dart';



class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId, 
      senderEmail: currentUserEmail, 
      receiverId: receiverID, 
      message: message,
      timestamp: timestamp
      );

    // construct chatroom id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverID];
    ids.sort(); // sort ids (this ensure the chat room id is always the same for any pair of names)
    String chatRoomId = ids.join(
      "_"); // combine the ids into a single string to use as a chatroomID

    // add new messages to database
    await _firestore
    .collection('chat_rooms')
    .doc(chatRoomId)
    .collection('messages')
    .add(newMessage.toMap());

  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chatroom id from users ids (sorted to ensure it matches the id user before)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
    .collection('chat_rooms')
    .doc(chatRoomId)
    .collection('messages')
    .orderBy('timeStamp', descending: false)
    .snapshots();
  }
}




