import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../pages/BreadPage.dart';
import '../pages/Condiments.dart';
import '../pages/FishPage.dart';
import '../pages/Fruits.dart';
import '../pages/Meat.dart';
import '../pages/Pasta.dart';
import '../pages/Vegetables.dart';

class Cart extends ChangeNotifier {

  final List<List<dynamic>> bread = [
    ["bread1", 0, "5", "images/bread/img1.jpeg",'BreadPage.id'],
    ["bread2", 0, "6", "images/bread/img2.jpeg",'BreadPage.id'],
    ["bread3", 0, "4", "images/bread/img3.jpeg",'BreadPage.id'],
    ["bread4", 0, "7", "images/bread/img4.jpeg",'BreadPage.id'],
    ["bread5", 0, "8", "images/bread/img5.jpeg",'BreadPage.id'],
    ["bread6", 0, "78", "images/bread/img6.jpeg",'BreadPage.id'],
    ["bread7", 0, "9", "images/bread/img7.jpeg",'BreadPage.id'],
    ["bread8", 0, "4.9", "images/bread/img8.jpeg",'BreadPage.id'],
  ];
  final List<List<dynamic>> fish = [
    ["Amnon", 0, "5", "images/fish/amnon.jpeg",'FishPage.id'],
    ["Buri", 0, "6", "images/fish/buri.jpeg",'FishPage.id'],
    ["Denis", 0, "4", "images/fish/denis.jpeg",'FishPage.id'],
    ["Solomon", 0, "7", "images/fish/salomon.jpeg",'FishPage.id'],
    ["Sardin", 0, "8", "images/fish/sardin.jpeg",'FishPage.id'],
  ];
  final List<List<dynamic>> condiments = [
    ["Black pepper", 0, "1", "images/condiments/blackpepper.jpeg",'Condiments.id'],
    ["Chili", 0, "3.9", "images/condiments/chili.jpeg",'Condiments.id'],
    ["Curry", 0, "2", "images/condiments/curry.jpeg",'Condiments.id'],
    ["Nutmeg", 0, "1.9", "images/condiments/Nutmeg.jpeg",'Condiments.id'],
    ["Spicy paprika", 0, "2", "images/condiments/spicypaprika.jpeg",'Condiments.id'],
    ["Sweet paprika", 0, "1", "images/condiments/sweetpaprika.jpeg",'Condiments.id'],
    ["Turmeric", 0, "0.5", "images/condiments/turmeric.jpeg",'Condiments.id'],
  ];
  final List<List<dynamic>> fruits = [
    ["Apple", 0, "6", "images/fruits/Apple.jpeg",'Fruits.id'],
    ["Banana", 0, "3", "images/fruits/Banana.jpeg",'Fruits.id'],
    ["Grapes", 0, "6", "images/fruits/grapes.jpeg",'Fruits.id'],
    ["Mango", 0, "1", "images/fruits/mango.jpeg",'Fruits.id'],
    ["Papia", 0, "2", "images/fruits/papia.jpeg",'Fruits.id'],
    ["Pear", 0, "6", "images/fruits/pear.jpeg",'Fruits.id'],
    ["Pineapple", 0, "5", "images/fruits/pineapple.jpeg",'Fruits.id'],
    ["Watermelon", 0, "8", "images/fruits/watermelon.jpeg",'Fruits.id'],
  ];
  final List<List<dynamic>> meat = [
    ["Foiegras", 0, "60", "images/meat/Foiegras.jpeg",'Meat.id'],
    ["Hearts", 0, "32", "images/meat/hearts.jpeg",'Meat.id'],
    ["Kebab", 0, "61", "images/meat/kebab.jpeg",'Meat.id'],
    ["Liver", 0, "34", "images/meat/liver.jpeg",'Meat.id'],
    ["Spring chicken", 0, "22", "images/meat/springchicken.jpeg",'Meat.id'],
    ["Steak", 0, "50", "images/meat/steak.jpeg",'Meat.id'],
    ["Sweet breads", 0, "45", "images/meat/Sweetbreads.jpeg",'Meat.id'],
  ];
  final List<List<dynamic>> pasta = [
    ["Cheese Ravioli", 0, "60", "images/pasta/Cheeseravioli.jpg",'Pasta.id'],
    ["Fettuccine", 0, "32", "images/pasta/Fettuccine.jpeg",'Pasta.id'],
    ["Mushroom Ravioli", 0, "61", "images/pasta/Mushroomravioli.jpeg",'Pasta.id'],
    ["Pappardella Pasta", 0, "34", "images/pasta/Pappardellapasta.jpeg",'Pasta.id'],
    ["Spaghetti", 0, "22", "images/pasta/spaghetti.jpeg",'Pasta.id'],
    ["Sweet Potato Ravioli", 0, "50", "images/pasta/Sweetpotatoravioli.jpeg",'Pasta.id'],
    ["Tortellini", 0, "45", "images/pasta/Tortellini.jpeg",'Pasta.id'],
  ];

  final List<List<dynamic>> vegetables = [
    ["broccoli", 0, "60", "images/vegetables/broccoli.jpeg",'Vegetables.id'],
    ["cabbage", 0, "32", "images/vegetables/cabbage.jpeg",'Vegetables.id'],
    ["coriander", 0, "61", "images/vegetables/coriander.jpeg",'Vegetables.id'],
    ["cucumber", 0, "34", "images/vegetables/cucumber.jpeg",'Vegetables.id'],
    ["eggplant", 0, "22", "images/vegetables/eggplant.jpeg",'Vegetables.id'],
    ["gamba", 0, "50", "images/vegetables/gamba.jpeg",'Vegetables.id'],
    ["HotPepper", 0, "45", "images/vegetables/HotPepper.jpeg",'Vegetables.id'],
    ["lemon", 0, "61", "images/vegetables/lemon.jpeg",'Vegetables.id'],
    ["Onion", 0, "34", "images/vegetables/Onion.jpeg",'Vegetables.id'],
    ["parsley", 0, "22", "images/vegetables/parsley.jpeg",'Vegetables.id'],
    ["Squash", 0, "50", "images/vegetables/Squash.jpeg",'Vegetables.id'],
    ["tomato", 0, "45", "images/vegetables/tomato.jpeg",'Vegetables.id'],
  ];

  void clear() {
    items.clear();
    notifyListeners();
  }

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

  void resetAllUnitsToZero() {
    for (List<List<dynamic>> itemList in [
      bread,
      fish,
      condiments,
      fruits,
      meat,
      pasta,
      vegetables,
    ]) {
      for (var item in itemList) {
        print("name of item: "+item[0]);
        item[1] = 0; // Reset the quantity to 0
        print("item reset to : "+item[1].toString());
      }
    }
    notifyListeners(); // Notify listeners about the change
  }

  // Method to reset unit of a specific item to 0 when removed from cart
  void resetUnitToZero(String itemName) {
    for (List<List<dynamic>> itemList in [
      bread,
      fish,
      condiments,
      fruits,
      meat,
      pasta,
      vegetables,
    ]) {
      final itemIndex = itemList.indexWhere((item) => item[0] == itemName);
      if (itemIndex != -1) {
        itemList[itemIndex][1] = 0;
        notifyListeners(); // Notify listeners about the change
        break; // Exit loop once the item is found and reset
      }
    }
  }
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

    // If the item is not in the cart and the unit is gretter then 0, add the product
    if (!itemExists && newItem[1] > 0) {
      items.add(newItem);
    }
    notifyListeners(); // update the list with the new changes
  }

//remove item from the cart
  void removeItem(int index) {
    //Removes an item from the cart based on its index.
    items.removeAt(index);
    notifyListeners();//The notifyListeners() method
    // is called whenever there is a change in the cart,
    // which notifies any listeners to rebuild and reflect the changes.
  }



  String calculate() {
    double total = 30;
    for (int i = 0; i < items.length; i++) {
      double unitPrice = double.parse(items[i][2]);
      int unitQuantity = items[i][1];
      total += unitPrice * unitQuantity;
    }
    return total.toStringAsFixed(2);
  }

  List<Map<String, dynamic>> searchItems(String query) {
    List<Map<String, dynamic>> searchResults = [];

    // Mapping of page names to their respective id values
    Map<String, String> pageRoutes = {
      'bread': BreadPage.id,
      'fish': FishPage.id,
      'condiments': Condiments.id,
      'fruits': Fruits.id,
      'meat': Meat.id,
      'pasta':Pasta.id,
      'vegetables': Vegetables.id

    };

    for (List<List<dynamic>> itemList in [
      bread,
      fish,
      condiments,
      fruits,
      meat,
      pasta,
      vegetables,
    ]) {
      for (List<dynamic> item in itemList) {
        if (item[0].toString().toLowerCase().contains(query.toLowerCase())) {
          searchResults.add({
            'itemDetails': item,
            'pageToNavigate': pageRoutes[itemList[0]] ?? HomePage.id,
          });
        }
      }
    }

    return searchResults;
  }
}
