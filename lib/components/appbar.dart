import 'package:flutter/material.dart';


PreferredSizeWidget myAppBar(String title) { 
  return AppBar(    
    backgroundColor: Colors.white, 
    centerTitle: true,
    title: Text(title),
  ); 
}

