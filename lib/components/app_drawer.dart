import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/c_home.dart';
import 'package:lft/learning-pages/learning_home.dart';
import 'package:lft/pray-for-tech-pages/pray4tech_main.dart';
import 'package:lft/profile-pages/profile_tab.dart';
import 'package:lft/settings-pages/settings.dart';

void signUserOut() { 
    FirebaseAuth.instance.signOut();
} 

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//get the current user
  final  currentUser = FirebaseAuth.instance.currentUser!;


Widget myDrawer(BuildContext context){ 
  return Drawer( 
    child: SingleChildScrollView( 
      child: Container( 
        margin:const EdgeInsets.only(top:50),
        padding: EdgeInsets.zero,
        child: Column(children: <Widget>[ 
           UserAccountsDrawerHeader(
            //display user's profile picture
            currentAccountPicture: IconButton( 
              onPressed: () { 
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) =>const ProfileTab()));
              },
              icon: const Icon(
                Icons.person,
                size: 48,
                color: Colors.white,
              ),
            ),
            
            //debating if we remove this
            otherAccountsPictures: const [ 
              Icon( 
                Icons.bookmark_border,
                color: Colors.white,
              ),
            ],

            //display current user's name and email
            accountName: const Text("Test Person"), 
            accountEmail:  Text(currentUser.email!),
      ),
            
          ListTile( 
            leading: const Icon(Icons.people),
            title: const Text("Community"),
            onTap:(){ 
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) =>CommunityTab()));
            }
          ),

          ListTile( 
            leading: const Icon(Icons.school),
            title: const Text("Learning"),
            onTap:(){ 
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) =>LearningTab()));
            }
          ),

          ListTile( 
            leading: const Icon(Icons.newspaper),
            title: const Text("Pray4Tech"),
            onTap:(){
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) =>Pray4TechTab()));
            }
          ),

          ListTile( 
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            //onTap: signUserOut,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) =>SettingsTab()));
            }
          ),  

        ],)
      )
    ),
  );
}