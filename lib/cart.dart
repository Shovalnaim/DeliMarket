import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<List<dynamic>> bread = [
    ["bread1", 0, "5", "images/bread/img1.jpeg"],
    ["bread2", 0, "6", "images/bread/img2.jpeg"],
    ["bread3", 0, "4", "images/bread/img3.jpeg"],
    ["bread4", 0, "7", "images/bread/img4.jpeg"],
    ["bread5", 0, "8", "images/bread/img5.jpeg"],
    ["bread6", 0, "78", "images/bread/img6.jpeg"],
    ["bread7", 0, "9", "images/bread/img7.jpeg"],
    ["bread8", 0, "4.9", "images/bread/img8.jpeg"],
  ];

  void updateUnit(String itemName, int newUnit) {
    //function that resive name of product and the change of units and update the units in cart
    final itemIndex = bread.indexWhere((item) => item[0] == itemName);
    if (itemIndex != -1) {
      bread[itemIndex][1] = newUnit;
      notifyListeners();
    }
  }

  List items = [];

  get shop => bread;

  get buyItem => items;

  void addItemToCart(int index) {
    List<dynamic> newItem = bread[index];
    String itemName = newItem[0];

    // Check if the item is already in the cart
    bool itemExists = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i][0] == itemName) {
        // Item already exists, update units
        updateUnit(itemName, newItem[1]);
        itemExists = true;
        break;
      }
    }
    // If the item is not in the cart, add the product
    if (!itemExists) {
      items.add(newItem);
    }
    notifyListeners(); //update the list with the new changes
  }

//remove item from the cart
  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  String calculate() {
    double total = 0;
    for (int i = 0; i < items.length; i++) {
      double unitPrice = double.parse(items[i][2]);
      int unitQuantity = items[i][1];
      total += unitPrice * unitQuantity;
    }
    return total.toStringAsFixed(2);
  }
}