import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

//class CommunityTab extends StatelessWidget {
class userGroupsTab extends StatefulWidget {
  
  static const title = 'Your Groups';
  static const androidIcon = Icon(Icons.person);

  //key
  userGroupsTab({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _userGroupPageState createState() => _userGroupPageState();

}

class _userGroupPageState extends State<userGroupsTab> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.grey[300], 
      appBar: myAppBar("Your Groups"),        //app bar -- see appbar.dart
      drawer: myDrawer(context),            //drawer options -- see app_drawer.dart
      bottomNavigationBar: bottomNavBar(),  //bottom nav bar -- see bottom_nav_bar.dart
      
      body: const Center(
        child: Text("Page to display the groups you are part of")),
        //use user.email! to display current users email     
    );
  }
}


