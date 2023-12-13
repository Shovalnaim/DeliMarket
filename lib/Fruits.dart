import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'GroceryItem.dart';
import 'cart.dart';
import 'cart_page.dart';

class Fruits extends StatelessWidget {
  static const String id="fruits";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFA3B02),
      appBar: AppBar(
        title: Text(
          "Fruits Page",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0XFFFA3B02),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 5,
                  ),
                ]),
            child: badges.Badge(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: Icon(
                  CupertinoIcons.cart,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        //child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Consumer<Cart>(builder: (context, value, child) {
                  return Container(
                    color: Color(0XFFFA3B02),
                    child: GridView.builder(
                      itemCount: value.fruits.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return GroceryItemTile(
                          name: value.fruits[index][0],
                          unit: value.fruits[index][1],
                          price: value.fruits[index][2],
                          image: value.fruits[index][3],
                          listName: value.fruits,
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .addItemToCart(
                                index,
                                Provider.of<Cart>(context, listen: false)
                                    .fruits);
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
