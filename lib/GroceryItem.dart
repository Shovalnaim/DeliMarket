import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class GroceryItemTile extends StatefulWidget {
  final String name;
  int unit;
  final String price;
  final String image;
  final List<List<dynamic>> listName;
  void Function()? onPressed;

  GroceryItemTile({
    Key? key,
    required this.name,
    this.unit = 0,
    required this.price,
    required this.image,
    required this.listName,
    required this.onPressed,
  });

  @override
  _GroceryItemTileState createState() => _GroceryItemTileState();
}

class _GroceryItemTileState extends State<GroceryItemTile> {

  void decrementUnit() {
    if (widget.unit > 0) {
      setState(() {
        widget.unit--;
        Provider.of<Cart>(context, listen: false)
            .updateUnit(widget.name, widget.unit,widget.listName);
      });
    }
  }
  void incrementUnit() {
    setState(() {
      widget.unit++;
      Provider.of<Cart>(context, listen: false)
          .updateUnit(widget.name, widget.unit,widget.listName);
    });
  }
  @override
  Widget build(BuildContext context) {
    return
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1)
              ]),
          child: Column(
            children: [
              Image.asset(
                widget.image,
                height: 100,
              ),
              Text(widget.name),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.all(7),
                child: Text(
                  "\$ ${widget.price} Per Unit",
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.unit > 0)  // Conditionally render based on unit value
                    InkWell(
                      onTap: () {
                        decrementUnit();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(CupertinoIcons.minus),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "${widget.unit}",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      incrementUnit();
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(CupertinoIcons.plus),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: Colors.brown, onPressed: widget.onPressed,
                    child: Text(
                      "Add To Cart",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],

              ),

            ],

          ),

    );
  }
}
