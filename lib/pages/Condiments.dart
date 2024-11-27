import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../GroceryItem.dart';
import '../components/cart.dart';
import 'cart_page.dart';

class Condiments extends StatelessWidget {
  static const String id = "condiments";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'images/backgroundthree.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Condiments Page",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30),
            ),
            centerTitle: true,
            actions: [
              Container(
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
                      print("תבלינים");
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
              )
            ],
          ),
        ),
        SafeArea(
            child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Expanded(
                child: Consumer<Cart>(builder: (context, value, child) {
                  return GridView.builder(
                    itemCount: value.condiments.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return GroceryItemTile(
                        name: value.condiments[index][0],
                        unit: value.condiments[index][1],
                        price: value.condiments[index][2],
                        image: value.condiments[index][3],
                        listName: value.condiments,
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .addItemToCart(
                                  index,
                                  Provider.of<Cart>(context, listen: false)
                                      .condiments);
                        },

                      );
                    },
                  );
                }),
              ),
            ],
          ),
        )),
      ]),
    );
  }
}