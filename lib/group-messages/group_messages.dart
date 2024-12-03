import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/components/appbar.dart';
import 'package:lft/group-messages/components/create_group.dart';
import 'package:lft/group-messages/components/join_group.dart';
import 'package:lft/group-messages/groupChat/group-chat-services.dart';
import 'package:lft/group-messages/groupChat/group-chatpage.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
   

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Groups'),
      bottomNavigationBar: bottomNavBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {setState(() {
                CreateGroup;
            });
              }, 
            child: Text("Create Group"),
          ),
          ElevatedButton(
            onPressed: () => JoinGroup, 
            child: Text("Join Group"),
          ),
        ],
      ),
    );
  }


  String receiverId = '';

  /* 
  This is basically the same code as the _buildUserList function in messages.
  Purpose: display all the groups the currentUser is a member of.
  Issue: We don't have a field in the database under data['Users'] which stores 
  the current groups a user is a part of. We would need to update the database which 
  feels counterproductive at this stage
  */
  Widget _buildGroupsList(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['username']),
        onTap: () {
          // pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupChatPage(
                groupId: data['id'],
              ),
            ),
          );
          receiverId = data['uid'];
        },
      );
    } else {
      // return empty container
      return Container();
    }
  }

  String getReceiverId(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return data['uid'];
  }
}


