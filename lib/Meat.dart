import 'package:flutter/material.dart';

class Meat extends StatelessWidget {
static const String id="meat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
          child: SafeArea(
            child: Text("meat"),
          )),
    );
  }
}
