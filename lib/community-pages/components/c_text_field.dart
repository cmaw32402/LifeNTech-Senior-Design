//This file contains frequently used components that can be quickly called, 
//this will prevent super bulky and verbose code 
import 'package:flutter/material.dart';

//This class creates text fields
class CTextField extends StatelessWidget{ 
  final controller;
  final String hintText;
  
  const CTextField({ 
    super.key,
    required this.controller, //used to access information inputted
    required this.hintText,   //subtle prompt for user
  });

  @override 
  Widget build(BuildContext context) { 
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField( 
              controller: controller, 
              decoration: InputDecoration( 
                enabledBorder: const OutlineInputBorder( 
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder( 
                  borderSide: BorderSide(color: Colors.grey.shade400)
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[800]),
              ),
            ),
          );
  }
}




