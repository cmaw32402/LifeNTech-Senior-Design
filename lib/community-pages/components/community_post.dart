import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lft/community-pages/components/comment.dart';
import 'package:lft/community-pages/components/like_button.dart';
import '../helper/helper_methods.dart';
import 'comment_button.dart';

class CommunityPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const CommunityPost({
    Key? key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) async {
    String? username = await getUsernameForCurrentUser();
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": username,
      "CommentTime": Timestamp.now()
    });
  }

  Future<String?> getUsernameForCurrentUser() async {
    String? currentUserEmail = currentUser.email;
    if (currentUserEmail != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
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

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
            controller: _commentTextController,
            decoration: InputDecoration(hintText: "Write a comment..")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //profile pic here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(
                        color: Color.fromARGB(255, 140, 140, 140)),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "-",
                    style: TextStyle(
                        color: Color.fromARGB(255, 140, 140, 140)),
                  ),
                  SizedBox(width: 4),
                  Text(
                    widget.time,
                    style: TextStyle(
                        color: Color.fromARGB(255, 140, 140, 140)),
                  ),
                ],
              ),
              Text(widget.message),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(width: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      return Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(color: Colors.grey),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: Text("Comments"),
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final commentData =
                          doc.data() as Map<String, dynamic>;
                      final commentText =
                          commentData["CommentText"] as String?;
                      final commentTime =
                          commentData["CommentTime"] as Timestamp?;
                      final commentUser = commentData["CommentedBy"]
                          as String;
                      if (commentText != null &&
                          commentTime != null &&
                          commentUser != null) {
                        return Comment(
                          text: commentText,
                          user: commentUser,
                          time: formatDate(commentTime),
                        );
                      } else {
                        // Handle null values or return a placeholder widget
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
