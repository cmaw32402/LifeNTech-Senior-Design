import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bibleQuote.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

import 'components/community_post.dart';
import 'helper/helper_methods.dart';

class CommunityTab extends StatefulWidget {
  static const title = 'Community';
  static const androidIcon = Icon(Icons.person);

  const CommunityTab({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CommunityTab> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  bool showBibleQuote = true;

  void postMessage() async {
    if (textController.text.isNotEmpty) {
      String? username = await getUsernameForCurrentUser();
      if (username != null) {
        FirebaseFirestore.instance.collection("User Posts").add({
          'User': username,
          'Message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        }).then((value) {
          setState(() {
            textController.clear();
          });
        }).catchError((error) {
          print("Failed to add post: $error");
        });
      } else {
        print("Failed to get username");
      }
    }
  }


  Future<String?> getUsernameForCurrentUser() async {
    String? currentUserEmail = currentUser.email;
    if (currentUserEmail != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: currentUserEmail)
                .get();

        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.get('username');
        } else {
          print("No user found with email: $currentUserEmail");
          return null;
        }
      } catch (error) {
        print("Error retrieving username: $error");
        return null;
      }
    } else {
      print("Current user email is null");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF522E51), 
      appBar: myAppBar("Community"),
      drawer: myDrawer(context),
      bottomNavigationBar: bottomNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4), // Reduce the height of the header
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust the padding
              child: FutureBuilder<String?>(
                future: getUsernameForCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "Welcome, Loading...",
                      style: TextStyle(fontSize: 20),
                       // Adjust the font size
                    );
                  }
                  
                  //This will print the current username
                  if (snapshot.hasData) {
                    return Container( 
                      child: 
                        


                        //welcome text
                        Text(
                         "Welcome, ${snapshot.data}!",
                            style: const TextStyle(
                             color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                           fontSize: 20
                        ), // Adjust the font size
                    ),);
                  }
                  return const Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 18, color: Colors.white), // Adjust the font size
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 2),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),           
            ),
          ),
          if (showBibleQuote)
            bibleQuote(
              onPressed: () {
                  setState(() {
                    showBibleQuote = !showBibleQuote;
                  });                                }
            ),          
          if (showBibleQuote == false)
            Row(
              children: [
                IconButton( 
                  icon: Icon(Icons.add_circle_outline, color: Colors.white), 
                  onPressed: () {
                    setState(() {
                        showBibleQuote = !showBibleQuote;
                      });
                    },              
                ),
                const Text( 
                  "Show Bible Quote",
                  style: TextStyle( 
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          
          //this will show the user's posts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy(
                    "TimeStamp",    //will filter by most recent
                    descending: false,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return CommunityPost(
                        message: post['Message'],
                        user: post['User'],
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                        time: formatDate(post['TimeStamp']),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
         Center(
           child: Container(
             decoration: const BoxDecoration(
               shape: BoxShape.circle, // Make it circular
               color: Color.fromARGB(255, 123, 59, 135), // Set background color
             ),
             child: IconButton(
               onPressed: () {
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       title: Text('Create a Post'),
                       content: TextField(
                         controller: textController,
                         decoration: InputDecoration(hintText: 'Write your post here...'),
                       ),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.pop(context);
                           },
                           child: Text('Cancel'),
                         ),
                         TextButton(
                           onPressed: () {
                             postMessage();
                             Navigator.pop(context); // Close the pop-up dialog after posting
                           },
                           child: Text('Post'),
                         ),
                       ],
                     );
                   },
                 );
               },
               icon: Icon(
                 Icons.add,
                 color: Colors.white,
               ),
               iconSize: 30,
             ),
           ),
         ),
        ],
      ),
    );
  
  
  
  }
}

