import 'package:flutter/material.dart';
import 'HomePage.dart';

class Start extends StatefulWidget {
  static const String id = "start";

  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Image.asset("images/imgdeli.jpeg")),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, HomePage.id);
              },
              child: Ink(
                  child: Text("Click here to Continue ",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
