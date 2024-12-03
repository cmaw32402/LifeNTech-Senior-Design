
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/login-pages/components/login_button.dart';
import 'package:lft/login-pages/components/login_texts.dart';
import 'package:lft/login-pages/components/square_tile.dart';

//import 'components/login_texts.dart';


class RegisterPage extends StatefulWidget { 
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers for user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user in method
  void signUserUp() async { 
    
    //show loading circle
    showDialog(
      context: context, 
      builder: (context) { 
        return const Center( 
          child: CircularProgressIndicator(),
        );
      },
    );
    
    //confirm both passowords are the same
    if(passwordController.text != confirmPasswordController.text ) { 
        //pop loading circle
        Navigator.pop(context);
        //show error to user
        showErrorMessage("Passwords don't match!");
        return;
    } 
  
    //try creating the user
    try {    
      //create user
      UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
      );

      //after creating new user, create new document in cloud firebase called Users
      FirebaseFirestore.instance 
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({ 
            'uid' : userCredential.user!.uid,
            'email' : userCredential.user!.email,
            'username' : emailController.text.split('@')[0],  //initial username
            'bio': 'Empty bio..' //initially empty bio
          });
  
      //pop loading circle
      if (context.mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) { 
      //pop loading circle
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
      //pop waiting circle
     // Navigator.pop(context);
  }

  //Wrong email message
  void showErrorMessage(String message) { 
    showDialog( 
      context: context,
      builder: (context) { 
        return AlertDialog( 
          backgroundColor: Colors.deepPurple,
          title: Center( 
            child: Text( 
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }



  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                const SizedBox(height: 25),
                //logo
                
                SizedBox(
                  width: 1000,
                  child: Image.asset(
                    'images/lifentech-new-logo.png',
                    height: 100,
                    width: 100,                   
                  )),
                //figure out how to adjust size of asset
                
                //Login Text
                const Text(
                  'Create an Account',
                  style: TextStyle(
                     color: Colors.white, 
                     fontSize: 20,
                   ),
                  ),
            
                //Add space
                const SizedBox(height: 20),
                
                //username textfield
                NewTextField( 
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                
                //add space
                const SizedBox(height: 10),
                
                //password textfield
                NewTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //add space
                const SizedBox(height: 10),

                //confirm password
                //password textfield
                NewTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                        
                //Add Space
                const SizedBox(height: 20),
                
                //sign in button
                NewButton(
                  onTap: signUserUp, 
                  text: 'Sign Up',
                ),
                
                //add space
                const SizedBox(height: 30),
                
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded( 
                        child: Divider( 
                        thickness: 0.5,
                        color: Colors.grey[400],
                        ),
                       ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.white)
                        ),
                      ),
                  
                      Expanded( 
                        child: Divider( 
                        thickness: 0.5,
                        color: Colors.grey[400],
                        ),
                       ),
                  
                    ],
                  ),
                ),
                
                //add space
                const SizedBox(height: 35),
                
                //google + apple sign in
                const Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    
                    //for google
                    SquareTile(imagePath: 'images/google_logo.png'),
                   
                    SizedBox(width: 25),
            
                    //for apple
                     SquareTile(imagePath: 'images/apple_logo.png'),
                  ]
                ),
                
                const SizedBox(height: 30), 
                // create account
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    const Text(
                      'Already have an account?',
                      style: TextStyle( 
                        color: Colors.white,
                      )
                    ),
                    const SizedBox(width: 4),
                   
                    GestureDetector( 
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle( 
                          color: Color.fromRGBO(6, 214, 253, 0.8),
                          fontWeight: FontWeight.bold,
                      ),
                      
                    ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}