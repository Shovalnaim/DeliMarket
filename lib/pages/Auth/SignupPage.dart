import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markettest/pages/Auth/Login_page.dart';

class SignupPage extends StatefulWidget {
  static const String id = "SignupPage";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confPass= TextEditingController();

  String email = '';
  String password = '';
  String confPass='';


  // void SignUp() async {
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     print('User register: ${credential.user!.email}');
  //     Navigator.pushNamed(context, LoginPage.id);
  //
  //   } catch (e) {
  //     print("Error During Registration: $e");
  //   }
  // }
  void SignUp() async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);


      // Accessing the Firebase Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check if the 'users' collection exists
      DocumentReference userRef = firestore.collection('users').doc(credential.user!.uid);

      // If 'users' collection doesn't exist, create it
      if (!(await userRef.get()).exists) {
        await firestore.collection('users').doc(credential.user!.uid).set({
          'email': email,

        });
      }
      print('User registered: ${credential.user!.email}');
      Navigator.pushNamed(context, LoginPage.id);
    } catch (e) {
      print("Error During Registration: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'images/backgroundthree.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),

       Center(
            child: Form(
              key: _globalKey ,
              child: Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white54,
                  ),
                  height: 450,
                  width: 300,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text("SignUp Page",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter Your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            print('email:'+email);
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter Your Password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                            print('pass:'+password);
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: _confPass,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter Your Password Again';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            confPass = value;
                            print('Confirm pass:'+confPass);
                          });
                        },
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(onPressed: (){
                        if(_globalKey.currentState!.validate()){
                          SignUp();
                        }
                      }, child: Text('Sign Up'))
                    ],
                  ),
                ),
              ),
            ),
          ),


      ]),
    );
  }
}
