import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'GroceryItem.dart';
import 'cart.dart';
import 'cart_page.dart';

class FishPage extends StatelessWidget {
  static const String id = "fish";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF14638C),
      appBar: AppBar(
        title: Text(
          "Fish Page",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0XFF5F94EE),
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
              Expanded(child: Consumer<Cart>(builder: (context, value, child) {
                return GridView.builder(
                  itemCount: value.fish.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return GroceryItemTile(
                      name: value.fish[index][0],
                      unit: value.fish[index][1],
                      price: value.fish[index][2],
                      image: value.fish[index][3],
                      listName: value.fish,
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false).addItemToCart(
                            index,
                            Provider.of<Cart>(context, listen: false).fish);
                      },
                    );
                  },
                );
              })),
            ],
          ),
        ),
      ),
    );
  }
}
