import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/community-pages/helper/helper_methods.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';
import 'package:lft/profile-pages/components/text_box.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key});

  @override
  State<ProfileTab> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileTab> {
  //get current user from database
  final currentUser = FirebaseAuth.instance.currentUser!;

  //all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field function
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(124, 111, 233, 1),
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.deepPurple),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          //save button
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    //update in firestore
    if (newValue.trim().isNotEmpty) {
      //only update if there is something in the textfield
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: myAppBar("Profile"),
      drawer: myDrawer(context),
      //AppBar(actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))]),
      bottomNavigationBar: bottomNavBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                //add space
                const SizedBox(height: 50),

                //profile picture
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                //user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50),

                //user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                //username
                MyTextBox(
                  sectionName: "Username",
                  text: userData['username'],             
                  onPressed: () => editField('username'),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),

                const SizedBox(height: 50),
                //user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection("User Posts").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      final userPosts = snapshot.data!.docs.where((doc) => doc['User'] == userData['username']);
                      if (userPosts.isEmpty) {
                        return Center(child: Text('No posts available.'));
                      }

                      return Column(
                        children: [
                          for (var doc in userPosts)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(doc['Message']),
                                subtitle: Text(formatDate((doc['TimeStamp'] as Timestamp))),
                              ),
                            ),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error${snapshot.error}'));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'));
          } else if (snapshot.data?.data() == null) {
            // Handle case when no data is available
            return Center(child: Text('No data available.'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}