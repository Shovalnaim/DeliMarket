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
  final List<List<dynamic>> fish = [
    ["Amnon", 0, "5", "images/fish/amnon.jpeg"],
    ["Buri", 0, "6", "images/fish/buri.jpeg"],
    ["Denis", 0, "4", "images/fish/denis.jpeg"],
    ["Solomon", 0, "7", "images/fish/salomon.jpeg"],
    ["Sardin", 0, "8", "images/fish/sardin.jpeg"],
  ];
  final List<List<dynamic>> condiments = [
    ["Black pepper", 0, "1", "images/condiments/blackpepper.jpeg"],
    ["Chili", 0, "3.9", "images/condiments/chili.jpeg"],
    ["Curry", 0, "2", "images/condiments/curry.jpeg"],
    ["Nutmeg", 0, "1.9", "images/condiments/Nutmeg.jpeg"],
    ["Spicy paprika", 0, "2", "images/condiments/spicypaprika.jpeg"],
    ["Sweet paprika", 0, "1", "images/condiments/sweetpaprika.jpeg"],
    ["Turmeric", 0, "0.5", "images/condiments/turmeric.jpeg"],
  ];
  final List<List<dynamic>> fruits = [
    ["Apple", 0, "6", "images/fruits/Apple.jpeg"],
    ["Banana", 0, "3", "images/fruits/Banana.jpeg"],
    ["Grapes", 0, "6", "images/fruits/grapes.jpeg"],
    ["Mango", 0, "1", "images/fruits/mango.jpeg"],
    ["Papia", 0, "2", "images/fruits/papia.jpeg"],
    ["Pear", 0, "6", "images/fruits/pear.jpeg"],
    ["Pineapple", 0, "5", "images/fruits/pineapple.jpeg"],
    ["Watermelon", 0, "8", "images/fruits/watermelon.jpeg"],
  ];
  final List<List<dynamic>> meat = [
    ["Foiegras", 0, "60", "images/meat/Foiegras.jpeg"],
    ["Hearts", 0, "32", "images/meat/hearts.jpeg"],
    ["Kebab", 0, "61", "images/meat/kebab.jpeg"],
    ["Liver", 0, "34", "images/meat/liver.jpeg"],
    ["Spring chicken", 0, "22", "images/meat/springchicken.jpeg"],
    ["Steak", 0, "50", "images/meat/steak.jpeg"],
    ["Sweet breads", 0, "45", "images/meat/Sweetbreads.jpeg"],
  ];
  final List<List<dynamic>> pasta = [
    ["Cheese Ravioli", 0, "60", "images/pasta/Cheeseravioli.jpg"],
    ["Fettuccine", 0, "32", "images/pasta/Fettuccine.jpeg"],
    ["Mushroom Ravioli", 0, "61", "images/pasta/Mushroomravioli.jpeg"],
    ["Pappardella Pasta", 0, "34", "images/pasta/Pappardellapasta.jpeg"],
    ["Spaghetti", 0, "22", "images/pasta/spaghetti.jpeg"],
    ["Sweet Potato Ravioli", 0, "50", "images/pasta/Sweetpotatoravioli.jpeg"],
    ["Tortellini", 0, "45", "images/pasta/Tortellini.jpeg"],
  ];

  final List<List<dynamic>> vegetables = [
    ["broccoli", 0, "60", "images/vegetables/broccoli.jpeg"],
    ["cabbage", 0, "32", "images/vegetables/cabbage.jpeg"],
    ["coriander", 0, "61", "images/vegetables/coriander.jpeg"],
    ["cucumber", 0, "34", "images/vegetables/cucumber.jpeg"],
    ["eggplant", 0, "22", "images/vegetables/eggplant.jpeg"],
    ["gamba", 0, "50", "images/vegetables/gamba.jpeg"],
    ["HotPepper", 0, "45", "images/vegetables/HotPepper.jpeg"],
    ["lemon", 0, "61", "images/vegetables/lemon.jpeg"],
    ["Onion", 0, "34", "images/vegetables/Onion.jpeg"],
    ["parsley", 0, "22", "images/vegetables/parsley.jpeg"],
    ["Squash", 0, "50", "images/vegetables/Squash.jpeg"],
    ["tomato", 0, "45", "images/vegetables/tomato.jpeg"],
  ];

  void updateUnit(String itemName, int newUnit, List<List<dynamic>> itemList) {
    //Updates the quantity of a specific item in the cart.
    // Parameters:
    // itemName: The name of the product.
    // newUnit: The new quantity of the product.
    // itemList: The list of items to update.
    final itemIndex = itemList.indexWhere((item) => item[0] == itemName);
    if (itemIndex != -1) {
      itemList[itemIndex][1] = newUnit;
      notifyListeners();
    }
  }

  List items = [];
//****I might need them later
  // get shop => bread;
  // get fh=>items;
  // get buyItem => items;
  // get cond=>items;


  void addItemToCart(int index, List<List<dynamic>> itemList) {
    //Adds an item to the shopping cart.
    // Parameters:
    // index: The index of the item in the product list.
    // itemList: The list of items to add the product from.
    // Checks if the item is already in the cart. If yes, it updates the quantity; otherwise, it adds the product to the cart.
    List<dynamic> newItem = itemList[index];
    String itemName = newItem[0];

    // Check if the item is already in the cart
    bool itemExists = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i][0] == itemName) {
        // Item already exists, update units
        updateUnit(itemName, newItem[1], itemList);
        itemExists = true;
        break;
      }
    }
    // If the item is not in the cart, add the product
    if (!itemExists) {
      items.add(newItem);
    }
    notifyListeners(); // update the list with the new changes
  }

//remove item from the cart
  void removeItem(int index) {
    //Removes an item from the cart based on its index.
    items.removeAt(index);
    notifyListeners();//The notifyListeners() method
    // is called whenever there is a change in the cart, which notifies any listeners to rebuild and reflect the changes.
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