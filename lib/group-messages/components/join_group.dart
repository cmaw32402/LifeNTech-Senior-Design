import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/group-messages-page/groupChat/group-chat-services.dart';
import 'package:lft/group-messages-page/groupChat/group-chatpage.dart';
import 'package:lft/login-pages/components/login_button.dart';
import 'package:lft/login-pages/components/login_texts.dart';
import 'package:lft/login-pages/components/square_tile.dart';

import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final TextEditingController _groupIdController = TextEditingController();
  final GroupService _groupService = GroupService();

  Future<void> _joinGroup() async {
    final groupId = _groupIdController.text.trim();
    if (groupId.isEmpty) {
      return; // Handle empty group ID error
    }
    await _groupService.joinGroup(groupId);
    Navigator.pop(context); // Navigate back after successful join
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupIdController,
              decoration: InputDecoration(
                labelText: 'Group ID',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _joinGroup,
              child: Text('Join Group'),
            ),
          ],
        ),
      ),
    );
  }
}
