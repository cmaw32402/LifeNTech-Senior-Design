import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/components/app_drawer.dart';
import 'package:lft/components/appbar.dart';
import 'package:lft/login-pages/auth_page.dart';
import 'package:lft/login-pages/components/login_button.dart';


 FirebaseAuth auth = FirebaseAuth.instance;


class SettingsTab extends StatefulWidget {
  static const title = 'Settings';
  static const androidIcon = Icon(Icons.school);
  //key
  //CommunityTab({super.key});
  SettingsTab({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<SettingsTab> {
  
  @override
  Widget build(BuildContext context) { 
    
    //log out user function
    Future logout() async {
      await auth.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),(route) => false)); 
}
    
    //make sure user wants to log out
    void confirmLogout() { 
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(124, 111, 233, 1),
          title: const Text(
            "Are you sure you would like to log out?", 
            style: TextStyle(color: Colors.white),
          ),
      
        actions: [            
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               //yes button 
               TextButton( 
                  onPressed: logout, 
                  child: const Text(
                    'Yes', 
                    style: TextStyle(color: Colors.white)
                    ),
                ),
                
                //no button
                TextButton( 
                  child: const Text(
                    'No', 
                    style: TextStyle(color: Colors.white)
                    ),
                    onPressed: () => Navigator.pop(context),
                ),
             ],
           ),            
          ],
        ),
      );
    }
       
    return Scaffold( 
      backgroundColor: Colors.grey[300], 
      appBar: myAppBar("Settings"),
      drawer: myDrawer(context),      
      
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Center(
            //child: Text("Settings Page")),
            child: Column(
              children: [ 
                  
                  //add space
                  const SizedBox(height: 300),
                  
                  //Logout button
                  NewButton(
                    onTap: confirmLogout, 
                    text: 'Log Out',
                  )
              ] 
            )
          ),
        ),
      )
    );
  }  
}