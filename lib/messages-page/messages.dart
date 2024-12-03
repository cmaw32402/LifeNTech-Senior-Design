import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/components/appbar.dart';
import 'package:lft/messages-page/chat/chat_pages.dart';


// class MessagesPage extends StatefulWidget {
//   const MessagesPage({super.key});
  

//   @override 
//   State<MessagesPage> createState() => _MessagesPageState();
// }

// class _MessagesPageState extends State<MessagesPage> {
//   // instance of auth
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override 
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar('Direct Messages'),
//       bottomNavigationBar: bottomNavBar(),
//       body: _buildUserList(),
//     );
//   }

//   // build a list of user except for current one
//   Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Users').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('error');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text('loading..');
//         }

//         return ListView(
//           children: snapshot.data!.docs
//           .map<Widget>((doc) => _buildUserListItem(doc))
//           .toList(),
//         );
//       },
//     );
//   }

//   String receiverId = '';

//   // build individual user list items
//   Widget _buildUserListItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

//     // display all users except current user
//     if (_auth.currentUser!.email != data['email']) {
//       return ListTile( 
//         title: Text(data['username']),
//         onTap: () {
//           // pass the clicked user's UID to the chat page
//           Navigator.push(
//             context, 
//             MaterialPageRoute(
//               builder: (context) => ChatPage(
//                 receiverUsername: data['username'],
//                 receiverUserID: data['uid'],
//               ),
              
//             ),
//           );
//           receiverId = data['uid'];
//         },
//       );
//     } else {
//       // return empty container
//       return Container();
//     }

//   }

//   String getReceiverId(DocumentSnapshot document) {
//       Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//       return data['uid'];
//   }


// }


class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Direct Messages'),
      bottomNavigationBar: bottomNavBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userDoc = snapshot.data!.docs[index];
              if (_auth.currentUser!.email != userDoc['email']) {
                return chatEntry(context, userDoc); // Use the chatEntry widget
              } else {
                return Container(); // Hide current user
              }
            },
          );
        },
      ),
    );
  }



//   Widget chatEntry(BuildContext context, DocumentSnapshot userDoc) {
//   final userData = userDoc.data()! as Map<String, dynamic>;
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 1.5),
//     child: Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200], // Light gray background
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 SizedBox(width: 16.0),
//                 Expanded( // Wrap content area with GestureDetector
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(
//                             receiverUsername: userData['username'],
//                             receiverUserID: userData['uid'],
//                           ),
//                         ),
//                       );
//                     },
//                     child: Column( // Content displayed on tap
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userData['username'],
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold, // Username style
//                             fontSize: 16.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget chatEntry(BuildContext context, DocumentSnapshot userDoc) {
  final userData = userDoc.data()! as Map<String, dynamic>;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.75),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light gray background
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: userData['avatarUrl'] != null
                      ? NetworkImage(userData['avatarUrl']!)
                      : null, // Display avatar image or placeholder
                  backgroundColor: Colors.grey[300], // Placeholder color
                ),
                SizedBox(width: 16.0),
                Expanded( // Wrap content area with GestureDetector
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverUsername: userData['username'],
                            receiverUserID: userData['uid'],
                          ),
                        ),
                      );
                    },
                    child: Column( // Content displayed on tap
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Username style
                            fontSize: 16.0,
                          ),
                        ),
                        if (userData['lastMessage'] != null) 
                          Text(
                            userData['lastMessage'],
                            maxLines: 1, // Truncate long messages
                            overflow: TextOverflow.ellipsis,
                          ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



}
