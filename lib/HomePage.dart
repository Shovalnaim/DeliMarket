import 'package:flutter/material.dart';
import 'package:markettest/pages/Auth/Login_page.dart';
import 'package:markettest/pages/BreadPage.dart';
import 'package:markettest/pages/Condiments.dart';
import 'package:markettest/pages/FishPage.dart';
import 'package:markettest/pages/Fruits.dart';
import 'package:markettest/pages/Meat.dart';
import 'package:markettest/pages/Pasta.dart';
import 'package:markettest/pages/Vegetables.dart';
import 'components/Orders_History.dart';
import 'components/cart.dart';
import 'components/settings.dart';
import 'pages/CategoriesWidget.dart';
import 'pages/cart_page.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isContainerVisible2 = true;
  TextEditingController _searchController = TextEditingController();
  Cart _cart = Cart();

  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> filteredItems =
      []; // list after filter the result of item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: badges.Badge(
                child: InkWell(
                  onTap: () {
                    print("CartPage");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );

                  },
                  child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: Container(
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage('images/backgroundthree.jpg'),
      //         fit: BoxFit.cover,
      //         colorFilter: ColorFilter.mode(
      //           Colors.black
      //               .withOpacity(0.5), // Adjust the opacity value (0.0 to 1.0)
      //           BlendMode.dstATop,
      //         ),
      //       ),
      //     ),
      //     child: ListView(
      //       children: [
      //         DrawerHeader(
      //           decoration: BoxDecoration(),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 'M E N U',
      //                 style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 24,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.list_alt_rounded),
      //           title: Text('My order list',
      //               style: TextStyle(fontWeight: FontWeight.bold)),
      //           onTap: () {
      //             // Navigate
      //           },
      //         ),
      //         ListTile(
      //           title: Text('????'),
      //           onTap: () {
      //             // Handle item 2 tap
      //           },
      //         ),
      //         // Add more ListTile if i need
      //       ],
      //     ),
      //   ),
      // ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundthree.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black
                    .withOpacity(0.5), // Adjust the opacity value (0.0 to 1.0)
                BlendMode.dstATop,
              ),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              SizedBox(
                height: 250,
              ),
              ListTile(
                title: Text('My Account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.pushNamed(context,Settings.id);

                },
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Orders History',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.pushNamed(context,OrdersHistory.id);
                },
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Home Page',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.pushNamed(context, HomePage.id); //בעיה של גודל עמוד
                },
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Log Out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.pushNamed(context, LoginPage.id);
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/backgroundthree.jpg',
            width: double.infinity, // Set your desired width
            height: double.infinity, // Set your desired height
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "welcome",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "what do you want to Buy?",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Filter the options based on the search query
                        var options = _cart
                            .searchItems(textEditingValue.text)
                            .map<String>((Map<String, dynamic> item) =>
                                item['itemDetails'][0].toString())
                            .toList();

                        print('Autocomplete Options: $options');

                        return options;
                      },
                      onSelected: (String selectedValue) {
                        // Find the selected item details in searchResults
                        String pageToNavigate = '';
                        for (var result in searchResults) {
                          if (result['itemDetails'][0].toString() ==
                              selectedValue) {
                            pageToNavigate =
                                result['itemDetails'][4].toString();

                            break;
                          }
                        }

                        print('Page to Navigate: $pageToNavigate');

                        if (pageToNavigate.isNotEmpty) {
                          // Ensure that pageToNavigate is not empty

                          switch (pageToNavigate) {
                            case 'BreadPage.id':
                              Navigator.pushNamed(context, BreadPage.id);
                              break;
                            case 'Vegetables.id':
                              Navigator.pushNamed(context, Vegetables.id);
                              break;
                            case 'Condiments.id':
                              Navigator.pushNamed(context, Condiments.id);
                              break;
                            case 'FishPage.id':
                              Navigator.pushNamed(context, FishPage.id);
                              break;
                            case 'Fruits.id':
                              Navigator.pushNamed(context, Fruits.id);
                              break;
                            case 'Meat.id':
                              Navigator.pushNamed(context, Meat.id);
                              break;
                            case 'Pasta.id':
                              Navigator.pushNamed(context, Pasta.id);
                              break;
                            default:
                              print('choose a different number!');
                          }
                        }
                        _searchController.clear();
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        _searchController = textEditingController;
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search items...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (String value) {
                            // Handle changes in the search query
                            setState(() {
                              searchResults = _cart.searchItems(value);
                            });
                          },
                        );
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected,
                          Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: Container(
                              height: 200,
                              child: ListView(
                                padding: EdgeInsets.all(8.0),
                                children: options
                                    .map<Widget>((String option) => ListTile(
                                          title: Text(option),
                                          onTap: () {
                                            onSelected(option);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // ),
                  ),

                  // CategoriesWidget displaying different product categories
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoriesWidget(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
