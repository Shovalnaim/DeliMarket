import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static const String id = "setting";

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? userEmail;
  String? newEmail;


  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<void> fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            userEmail = (snapshot.data() as Map<String, dynamic>?)?['email'];
          });
        } else {
          print("Document does not exist");
        }
      } catch (e) {
        print('Error fetching user email: $e');
      }
    } else {
      print('User is not logged in');
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Verification email sent to $email. Please verify and then update the email.')),
      );
    } catch (e) {
      print('Error sending verification email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending verification email: $e')),
      );
    }
  }

  Future<void> reauthenticateUser(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        print('Error reauthenticating user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reauthenticating user: $e')),
        );
      }
    }
  }

  Future<void> updateEmail(String newEmail, String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Step 1: Re-authenticate user
        await reauthenticateUser(password);

        // Step 2: Send verification email
        await sendVerificationEmail(newEmail);

        // Note: Actual email update will occur after user verifies the new email through the link sent by Firebase.
        // Therefore, updating the Firestore email immediately may not be accurate. It's better to update Firestore
        // after the email is verified.

        // Show message to the user to check email for verification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Email will be updated after verification. Please check your email.')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please re-login before updating email')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating email: ${e.message}')),
          );
        }
      } catch (e) {
        print('Error updating email: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    } else {
      print('User is not logged in');
    }
  }

  Future<void> updatePass(String newPassword, String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Step 1: Re-authenticate user
        await reauthenticateUser(currentPassword);

        // Step 2: Update password in Firebase Authentication
        await user.updatePassword(newPassword);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please re-login before updating password')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating password: ${e.message}')),
          );
        }
      } catch (e) {
        print('Error updating password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
      }
    } else {
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/backgroundthree.jpg', // Path to your image asset
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5), // Adjust opacity here
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 250),
                  Row(
                    children: [
                      Icon(Icons.email),
                      Expanded(
                        child: Center(
                          child: userEmail != null
                              ? Text(
                                  ' Email: $userEmail',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                  ),
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Show dialog to enter new email
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController emailController =
                                  TextEditingController();
                              TextEditingController passwordController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text('Change Email'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter new email',
                                      ),
                                    ),
                                    TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your current password',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Update'),
                                    onPressed: () {
                                      String newEmail =
                                          emailController.text.trim();
                                      String password =
                                          passwordController.text.trim();
                                      if (newEmail.isNotEmpty &&
                                          password.isNotEmpty) {
                                        // Call update email function
                                        setState(() {
                                          this.newEmail = newEmail;
                                        });
                                        updateEmail(newEmail, password);
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Please enter valid email and password'),
                                        ));
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.lock),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController newPasswordController =
                                    TextEditingController();
                                TextEditingController
                                    currentPasswordController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: Text('Change Password'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: newPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new password',
                                        ),
                                      ),
                                      TextField(
                                        controller: currentPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter your current password',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                         String newPassword =
                                            newPasswordController.text.trim();
                                       String currentPassword =
                                            currentPasswordController.text
                                                .trim();
                                        if (newPassword.isNotEmpty &&
                                            currentPassword.isNotEmpty) {

                                          updatePass(
                                              newPassword, currentPassword);
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please enter valid passwords'),
                                          ));
                                        }
                                      },
                                      child: Text('Update password'),
                                    )
                                  ],
                                );
                              });
                        },
                      )
                    ],
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
