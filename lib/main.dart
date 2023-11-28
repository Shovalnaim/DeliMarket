import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:markettest/BreadPage.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/StartPage.dart';
import 'package:markettest/cart.dart';
import 'package:provider/provider.dart';

import 'CategoriesWidget.dart';

// void main() {
//   runApp(const MyApp());
// }
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Start.id,
      routes: {
        Start.id:(context)=>Start(),
        BreadPage.id: (context) => BreadPage(),
        HomePage.id:(context)=>HomePage(),
        CategoriesWidget.id:(context)=>CategoriesWidget()
        // Add more routes as needed
      },
    );
  }
}
