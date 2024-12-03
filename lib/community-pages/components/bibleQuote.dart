import 'package:flutter/material.dart';

class bibleQuote extends StatelessWidget {

  final void Function()? onPressed;
  bibleQuote({
    super.key,
    required this.onPressed,
  });

  @override 
  Widget build(BuildContext context) {
    return Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the content center horizontally
                  children: [
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         const Text(
                          "Bible Quote of The Day", // Update the title
                          style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                      ),
                    ),                                                
                         IconButton( 
                          icon: const Icon( 
                            Icons.remove_circle_outline,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: onPressed,              
                         ),                                            
                    ]
                    ),
                   
                    SizedBox(height: 8),
                    const Text(
                      "Not only so, but we also glory in our sufferings, because we know that suffering produces perseverance; perseverance, character; and character, hope. \nRomans 5:3-4",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
}
}