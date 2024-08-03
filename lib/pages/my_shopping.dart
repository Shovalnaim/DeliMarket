import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../components/cart.dart';
import 'cart_page.dart';

//דף הזה יהיה הדף של כל ההזמנה שתפתח ללקוח

class myshopping extends StatefulWidget {
  const myshopping({super.key});
  static const String id = "shopping";

  @override
  State<myshopping> createState() => _myshoppingState();
}

class _myshoppingState extends State<myshopping> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}