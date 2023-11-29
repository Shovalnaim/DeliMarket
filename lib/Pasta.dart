import 'package:flutter/material.dart';


class Pasta extends StatelessWidget {
  static const String id='pasta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
          child: SafeArea(
            child: Text("pasta"),
          )),
    );
  }
}
