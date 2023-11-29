import 'package:flutter/material.dart';

class Fruits extends StatelessWidget {
  static const String id="fruits";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
          child: SafeArea(
        child: Text("fruits"),
      )),
    );
  }
}
