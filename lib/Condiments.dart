import 'package:flutter/material.dart';

class Condiments extends StatelessWidget {
  static const String id = "condiments";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
          child: SafeArea(
        child: Text("condiments"),
      )),
    );
  }
}
