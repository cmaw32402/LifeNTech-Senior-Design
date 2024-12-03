import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lft/login-pages/components/login_button.dart';
import 'package:lft/login-pages/components/square_tile.dart';

import 'components/login_texts.dart';


class LoginPage extends StatefulWidget { 
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers for user input
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async { 
    
    //show loading circle
    showDialog(
      context: context, 
      builder: (context) { 
        return const Center( 
          child: CircularProgressIndicator(),
        );
      },
    );
    
    //try sign in
    try { 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
      //pop loading circle
      Navigator.pop(context);

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
                Image.asset('images/lifentech-new-logo.png'),
               
                //Login Text
                const Text(
                  'Welcome Back!',
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
            
                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[300]),
                        ),
                    ],
                  ),
               ),
            
                //Add Space
                const SizedBox(height: 20),
                
                //sign in button
                NewButton(
                  onTap: signUserIn, 
                  text: 'Sign In',
                  
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
                      'Not a member?',
                      style: TextStyle( 
                        color: Colors.white,
                      )
                    ),
                    
                    const SizedBox(width: 4),
                   
                    GestureDetector( 
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
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