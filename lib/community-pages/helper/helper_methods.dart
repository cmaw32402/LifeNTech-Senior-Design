import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  String formattedData = '$month/$day/$year'; 

  return formattedData;
  
}
getCurrentUsername(String currentUserEmail) async {
  String? currentUsername;

  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: currentUserEmail)
      .get();

  if (snapshot.docs.isNotEmpty) {
    currentUsername = snapshot.docs.first.get('username');
  }

  return currentUsername;
}

