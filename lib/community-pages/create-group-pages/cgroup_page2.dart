import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/community-pages/components/c_text_field.dart';
import 'package:lft/community-pages/components/myButton.dart';
import 'package:lft/community-pages/components/sectionBox.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';

//class CommunityTab extends StatelessWidget {
class CreateGroupPageTwo extends StatefulWidget {
  
  static const title = 'Search';
  static const androidIcon = Icon(Icons.person);

  //key
  CreateGroupPageTwo({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _CGPageTwoState createState() => _CGPageTwoState();

}

class _CGPageTwoState extends State<CreateGroupPageTwo> {
  
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
          
          sectionBox(
            text: 'Feel free to be creative with how you name your group! This is what the user will'
            'first see when exploring groups.\n\n',  
            sectionName: 'Name Your Group',
            onPressed: () {},
          ),

          //add space
          SizedBox(height: 150),

          //Ask user for name of their group
          CTextField(
            controller: GroupNameController, 
            hintText: "What would you like to name your group?", 
          ),
          
          //add space
          SizedBox(height: 150),

          NewButton(
            text: 'Next',
            onTap: () { }
          )

        ],
   
        
      ),
        //use user.email! to display current users email     
    );
  }
}

