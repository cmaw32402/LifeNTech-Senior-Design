import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';


class LearningTab extends StatefulWidget {
  
  static const title = 'Learning';
  static const androidIcon = Icon(Icons.school);

  //key
  //CommunityTab({super.key});
  LearningTab({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<LearningTab> {
   //sign user out method
  void signUserOut() { 
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.grey[300], 
      appBar: myAppBar("Learning"),
      drawer: myDrawer(context),
      //AppBar(actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))]),
      //bottomNavigationBar: communityBottomNavBar(),
      
      body: const Center(
        child: Text("Learning Page")),
        //use user.email! to display current users email
      
    );
  }
}