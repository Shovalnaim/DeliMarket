import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'GroceryItem.dart';
import 'components/cart.dart';
import 'pages/cart_page.dart';

class Condiments extends StatelessWidget {
  static const String id = "condiments";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFA62727),
      appBar: AppBar(
        title: Text(
          "Condiments Page",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0XFFA62727),
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
        ),
      ),
    );
  }
}
