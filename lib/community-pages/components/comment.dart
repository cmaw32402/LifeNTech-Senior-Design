import 'package:flutter/material.dart';
//comment
class Comment extends StatelessWidget{
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key, 
    required this.text, 
    required this.user,
    required this.time,
});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             Text(
                user, 
                style: TextStyle(color: Color.fromARGB(255, 140, 140, 140)),
              ),
              SizedBox(width: 4),
              Text("-",
              style: TextStyle(color: Color.fromARGB(255, 140, 140, 140)),),
              SizedBox(width: 4),
              Text(
                time, 
                style: TextStyle(color: Color.fromARGB(255, 140, 140, 140)),
              ),
            ],
          ),
          Text(text),

          const SizedBox(height: 5),

        ],
      )
    );
  }
}