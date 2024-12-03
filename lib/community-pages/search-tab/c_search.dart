import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/community-pages/components/bottom_nav_bar.dart';
import 'package:lft/profile-pages/pub_profile_tab.dart';

//class CommunityTab extends StatelessWidget {
class CommunitySearchTab extends StatefulWidget {

  

  static const title = 'Search';
  static const androidIcon = Icon(Icons.person);

  //key
  CommunitySearchTab({super.key});
  //user
  final user = FirebaseAuth.instance.currentUser!;

  

  @override
 _CSearchPageState createState() => _CSearchPageState();

}

class _CSearchPageState extends State<CommunitySearchTab> {
  String name = "";
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.grey[300], 
      bottomNavigationBar: bottomNavBar(),
      appBar: AppBar(
            title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                 

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            data['username'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(Icons.person),
                          onTap: () {
                           Navigator.pop(context);
                           Navigator.push(
                             context, 
                            MaterialPageRoute(
                              builder: (context) => PubProfileTab(
                                 userName: data['username'],
                          )));
                          },
                        );
                      }
                      if (data['username']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['username'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),                         
                          leading: const Icon(Icons.person),
                          onTap: () { 
                            Navigator.pop(context);
                           Navigator.push(
                             context, 
                            MaterialPageRoute(
                              builder: (context) => PubProfileTab(
                                 userName: data['username'],
                        )));
                          }
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}


