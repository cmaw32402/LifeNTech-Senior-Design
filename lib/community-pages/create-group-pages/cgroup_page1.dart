import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/community-pages/components/myButton.dart';
import 'package:lft/community-pages/components/sectionBox.dart';
import 'package:lft/community-pages/create-group-pages/cgroup_page2.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

//class CommunityTab extends StatelessWidget {
class CreateGroupPageOne extends StatefulWidget {
  
  static const title = 'Search';
  static const androidIcon = Icon(Icons.person);

  //key
  CreateGroupPageOne({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _CGPageOneState createState() => _CGPageOneState();

}

class _CGPageOneState extends State<CreateGroupPageOne> {
  
  //stores group name
  final GroupNameController = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.grey[400], 
      appBar: myAppBar("Create New Group"),        //app bar -- see appbar.dart
      drawer: myDrawer(context),            //drawer options -- see app_drawer.dart
      bottomNavigationBar: bottomNavBar(),  //bottom nav bar -- see bottom_nav_bar.dart
      
      body: Column(
        children: [
          //add space
          SizedBox(height: 100),

          sectionBox(
            text: 'This is the group creation menu, where you can create a virtual community '
            'and communicate with others with similar interests.\n\n\n'
            'This will also contain more general information about this feature before a user'
            'actually goes through with the process -- i.e. community guidelines and advice to'
            'make sure a group like this does not already exist',
            sectionName: 'About Groups',
            onPressed: () {},
          ),

          //add space
          SizedBox(height: 35),


          //Navigate user to next page with a button
          NewButton(
            text: 'Next',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) =>CreateGroupPageTwo()));             
             }
          )

        ],
        /* //Ask user for name of their group
          CTextField(
            controller: GroupNameController, 
            hintText: "What would you like to name your group?", 
            ),
 */
        
      ),
        //use user.email! to display current users email     
    );
  }
}

