import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/mmodel/groups.dart';
import 'package:lft/group-messages-page/group_messages.dart';



import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGroup(String groupName, List<String> userIds) async {
    final docRef = await _firestore.collection('groups').add({
      'name': groupName,
      'users': userIds,
    });
    final groupId = docRef.id; // Access AutoID from DocumentReference
  }

  Stream<Group> getGroup(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((docSnapshot) => Group.fromMap(docSnapshot.data()!));
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String groupId, String message) async {
    final docRef = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add({
          'sender': FirebaseAuth.instance.currentUser!.uid,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> joinGroup(String groupId) async {
    // Implement logic to add current user ID to the "users" list in the group document
    final groupDoc = await _firestore.collection('groups').doc(groupId).get();
    if (groupDoc.exists) {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final List<String> users = (groupDoc.data()!['users'] as List<dynamic>).cast<String>();
      if (!users.contains(currentUserId)) {
        users.add(currentUserId);
        await _firestore.collection('groups').doc(groupId).update({'users': users});
      }
    }
  }
}

