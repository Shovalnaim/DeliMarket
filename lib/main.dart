import 'package:flutter/material.dart';
import 'package:markettest/pages/BreadPage.dart';
import 'package:markettest/Condiments.dart';
import 'package:markettest/pages/FishPage.dart';
import 'package:markettest/pages/Fruits.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/Meat.dart';
import 'package:markettest/StartPage.dart';
import 'package:markettest/components/cart.dart';
import 'package:markettest/pages/Pay.dart';
import 'package:provider/provider.dart';
import 'CategoriesWidget.dart';
import 'pages/Pasta.dart';
import 'pages/Vegetables.dart';
import 'pages/deliveryPage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // the app might be using the Provider package for state management.
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Start.id,
      routes: {
        //Defining routes for different pages using a route map.
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
        Pay.id:(context)=>Pay()

      },
    );
  }
}
