import 'package:flutter/material.dart';

class Vegetables extends StatelessWidget {
  static const String id="vegetables";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
          child: SafeArea(
            child: Text("Vegetables"),
          )),
    );
  }
}
