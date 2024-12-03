import 'package:flutter/material.dart';

class bibleQuoteButton extends StatelessWidget {
  final void Function()? onPressed;
  bibleQuoteButton({
    super.key,
    required this.onPressed,
  });

@override 
Widget build(BuildContext context) {
  return IconButton(
    onPressed: onPressed, 
    icon: Icon(Icons.maximize), 
  );

}

}
