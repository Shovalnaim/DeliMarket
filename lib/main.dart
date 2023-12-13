import 'package:flutter/material.dart';
import 'package:markettest/pages/BreadPage.dart';
import 'package:markettest/Condiments.dart';
import 'package:markettest/pages/FishPage.dart';
import 'package:markettest/pages/Fruits.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/Meat.dart';
import 'package:markettest/StartPage.dart';
import 'package:markettest/components/cart.dart';
import 'package:provider/provider.dart';
import 'CategoriesWidget.dart';
import 'pages/Pasta.dart';
import 'pages/Vegetables.dart';
import 'pages/deliveryPage.dart';

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
        CategoriesWidget.id:(context)=>CategoriesWidget(),
        Vegetables.id:(context)=>Vegetables(),
        Pasta.id:(context)=>Pasta(),
        Meat.id:(context)=>Meat(),
        Fruits.id:(context)=>Fruits(),
        Condiments.id:(context)=>Condiments(),
        FishPage.id:(context)=>FishPage(),
        Deli.id:(context)=>Deli(),

      },
    );
  }
}
