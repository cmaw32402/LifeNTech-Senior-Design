import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/c_home.dart';
import 'package:lft/community-pages/c_user_groups.dart';
import 'package:lft/community-pages/search-tab/c_search.dart';
import 'package:lft/messages-page/messages.dart';

class bottomNavBar extends StatefulWidget {
  

  //key
  //CommunityTab({super.key});
  bottomNavBar({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  @override
 _bottomNavBar createState() => _bottomNavBar();

}


class _bottomNavBar extends State<bottomNavBar> {

  int _currentIndex = 0;

  final  tabs = [
    const Center(child: Text("Community")),
    const Center(child: Text("Messages")),
    const Center(child: Text("Search")),
    const Center(child: Text("Groups")),
  ];

  @override 
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Color.fromRGBO(6, 214, 253, 1),
        iconSize: 25,
        items: const [
           BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "",
            backgroundColor:  Color.fromRGBO(51, 51, 51, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: "",
            backgroundColor:  Color.fromRGBO(51, 51, 51, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
            backgroundColor:  Color.fromRGBO(51, 51, 51, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: "",
            backgroundColor:  Color.fromRGBO(51, 51, 51, 1),
          )
        ],
        // Determines what happens once a button is clicked
        onTap: (index){
          setState(() {
            _currentIndex = index;
            if(_currentIndex == 0) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityTab()));
            }
            if(_currentIndex == 1) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesPage()));
            }
            if(_currentIndex == 2) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunitySearchTab()));
            }
            if(_currentIndex == 3) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => userGroupsTab()));
            }
          });
        },
      );
    
  }
}