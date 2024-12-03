import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    super.key,
    required this.message
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(124, 111, 233, 1)
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 17, color: Colors.white),
      ),
    );
  }
}