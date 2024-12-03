import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/community-pages/helper/helper_methods.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

class PubProfileTab extends StatelessWidget {
  final String userName;
  const PubProfileTab({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: myAppBar("Profile"),
      drawer: myDrawer(context),
      bottomNavigationBar: bottomNavBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").where('username', isEqualTo: userName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

            return ListView(
              children: [
                SizedBox(height: 50),
                Icon(
                  Icons.person,
                  size: 72,
                ),
                Text(
                  userData['email'],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ListTile(
                  title: Text('Username'),
                  subtitle: Text(userData['username']),
                ),
                ListTile(
                  title: Text('Bio'),
                  subtitle: Text(userData['bio']),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("User Posts").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      final userPosts = snapshot.data!.docs.where((doc) => doc['User'] == userName);
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
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}