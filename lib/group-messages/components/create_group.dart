import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/group-messages-page/groupChat/group-chat-services.dart';
import 'package:lft/group-messages-page/groupChat/group-chatpage.dart';
import 'package:lft/login-pages/components/login_button.dart';
import 'package:lft/login-pages/components/login_texts.dart';
import 'package:lft/login-pages/components/square_tile.dart';

import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedUsers = [];
  final GroupService _groupService = GroupService();

  // Mock data for selectable users (replace with actual user fetching logic)
  final List<String> _allUsers = ['user1@example.com', 'user2@example.com', 'user3@example.com'];

  void _handleUserSelection(String userId, bool isSelected) {
    if (isSelected) {
      setState(() {
        _selectedUsers.add(userId);
      });
    } else {
      setState(() {
        _selectedUsers.remove(userId);
      });
    }
  }

  Future<void> _createGroup() async {
    final groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) {
      return; // Handle empty group name error
    }
    await _groupService.createGroup(groupName, _selectedUsers);
    Navigator.pop(context); // Navigate back after successful creation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
              ),
            ),
            SizedBox(height: 10.0),
            Text('Select Users'),
            CheckboxListTile(
              title: Text(_allUsers[0]),
              value: _selectedUsers.contains(_allUsers[0]),
              onChanged: (value) => _handleUserSelection(_allUsers[0], value!),
            ),
            // Repeat CheckboxListTile for other users in _allUsers
            ..._allUsers.sublist(1).map((userId) => CheckboxListTile(
              title: Text(userId),
              value: _selectedUsers.contains(userId),
              onChanged: (value) => _handleUserSelection(userId, value!),
            )),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
