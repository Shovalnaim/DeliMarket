import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/CategoriesWidget.dart';
import '../../components/func.dart';
import 'ResetPage.dart';
import 'SignupPage.dart';
import '../deliveryPage.dart';

class LoginPage extends StatefulWidget {
  static const String id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  // Function to handle user sign-in
  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      // Sign in with Firebase using email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        HomePage.id,
      ); // Navigate to the CategoriesWidget on successful sign-in
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the CircularProgressIndicator dialog
      errorMessage(context, e.code);
    }
  }

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/backgroundthree.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white54,
                        ),
                        height: 450,
                        width: 300,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Login Page",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email",
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passController,
                              obscureText: obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 60.0),
                                decoration: BoxDecoration(
                                  color: Color(0XFFF1CB10),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign-In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, ResetPage.id);
                              },
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, SignupPage.id);
                              },
                              child: Text(
                                'New User App ? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:markettest/HomePage.dart';
// import 'package:markettest/pages/CategoriesWidget.dart';
// import '../../components/func.dart';
// import 'ResetPage.dart';
// import 'SignupPage.dart';
// import '../deliveryPage.dart';
//
// class LoginPage extends StatefulWidget {
//   static const String id = "LoginPage";
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passController = TextEditingController();
//   //final confPassController=TextEditingController();
//
//   // Function to handle user sign-in
//   void signIn() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//     try {
//       // Sign in with Firebase using email and password
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passController.text,
//       );
//
//       Navigator.pop(context);
//       Navigator.pushNamed(
//           context,
//           HomePage
//               .id); // Navigate to the CategoriesWidget on successful sign-in
//     } on FirebaseAuthException catch (e) {
//       Navigator.pop(context); // Close the CircularProgressIndicator dialog
//       errorMessage(context, e.code);
//     }
//   }
//
//   bool obscurePassword = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//           children: [
//         Image.asset(
//           'images/backgroundthree.jpg',
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//         ),
//         Expanded(
//           flex: 1,
//           child: Center(
//               child: Container(
//             padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: Colors.white54,
//             ),
//             height: 450,
//             width: 300,
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   "Login Page",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Email",
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: passController,
//                   obscureText: obscurePassword,
//                   keyboardType: TextInputType.visiblePassword,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Password",
//                       suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               obscurePassword = !obscurePassword;
//                             });
//                           },
//                           icon: Icon(
//                             obscurePassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ))),
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () {
//                     signIn();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(10.0),
//                     margin: const EdgeInsets.symmetric(horizontal: 60.0),
//                     decoration: BoxDecoration(
//                       color: Color(0XFFF1CB10),
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(50.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Sign-In',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, ResetPage.id);
//                   },
//                   child: Text(
//                     'Forgot your password?',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         decoration: TextDecoration.underline),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, SignupPage.id);
//                   },
//                   child: Text(
//                     'New User App ? ',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         decoration: TextDecoration.underline),
//                   ),
//                 ),
//               ],
//             ),
//           )),
//         )
//       ]),
//     );
//   }
// }
