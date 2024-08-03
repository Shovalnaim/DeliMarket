//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markettest/firebase_options.dart';
import 'package:markettest/pages/Auth/ResetPage.dart';
import 'package:markettest/pages/Auth/SignupPage.dart';
import 'package:markettest/pages/BreadPage.dart';
import 'package:markettest/pages/Condiments.dart';
import 'package:markettest/pages/FishPage.dart';
import 'package:markettest/pages/Fruits.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/Auth/Login_page.dart';
import 'package:markettest/pages/Meat.dart';
//import 'package:markettest/StartPage.dart';
import 'package:markettest/components/cart.dart';
import 'package:markettest/pages/Pay.dart';
import 'package:markettest/pages/cart_page.dart';
import 'package:markettest/pages/my_shopping.dart';
import 'package:markettest/pages/order.dart';
import 'package:provider/provider.dart';
import 'components/Orders_History.dart';
import 'components/settings.dart';
import 'GroceryItem.dart';
import 'components/locations_user.dart';
import 'pages/CategoriesWidget.dart';
import 'pages/Pasta.dart';
import 'pages/Vegetables.dart';
import 'pages/deliveryPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with specified options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
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
      initialRoute: LoginPage.id,

      //initialRoute: Pay.id,
      routes: {
        //Defining routes for different pages using a route map.
        //Start.id:(context)=>Start(),
        MapPage.id:(context)=>MapPage(),
        SignupPage.id:(context)=>SignupPage(),
        LoginPage.id:(context)=>LoginPage(),
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
        Pay.id:(context)=>Pay(),
        CartPage.id:(context)=>CartPage(),
        ResetPage.id:(context)=>ResetPage(),
        FinalOrder.id:(context)=>FinalOrder(),
        myshopping.id:(context)=>myshopping(),
        Settings.id:(context)=>Settings(),
        OrdersHistory.id:(context)=>OrdersHistory()
        //local.Settings.id:(context)=>local.Settings() // Use the 'local' prefix
        //Search.id:(context)=>Search()

      },
    );
  }
}
