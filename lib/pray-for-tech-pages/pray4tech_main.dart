import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

//class CommunityTab extends StatelessWidget {
class Pray4TechTab extends StatefulWidget {
  
  static const title = 'Pray4Tech';
  static const androidIcon = Icon(Icons.newspaper);

  //key
  //CommunityTab({super.key});
  Pray4TechTab({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _Pray4TechState createState() => _Pray4TechState();

}

class _Pray4TechState extends State<Pray4TechTab> {
   //sign user out method
  void signUserOut() { 
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.grey[300], 
      appBar: myAppBar("Pray4Tech"),
      drawer: myDrawer(context),
     // bottomNavigationBar: const communityBottomNavBar(),
      
      body: const Center(
        child: Text("Pray 4 Tech")),
        //use user.email! to display current users email     
    );
  }
}


