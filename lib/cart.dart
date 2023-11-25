import 'package:flutter/material.dart';

class Cart extends ChangeNotifier{

  final List shopping=[

    ["bread1","5","images/bread/img1.jpeg"],
    ["bread2","6","images/bread/img2.jpeg"],
    ["bread3","4","images/bread/img3.jpeg"],
    ["bread4","7","images/bread/img4.jpeg"],
  ];
  get shop=>shopping;
}