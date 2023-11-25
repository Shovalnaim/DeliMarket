import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroceryItemTile extends StatefulWidget {
  final String name;
  int unit;
  final String price;
  final String image;

  GroceryItemTile({
    Key? key,
    required this.name,
    this.unit = 0,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  _GroceryItemTileState createState() => _GroceryItemTileState();
}

class _GroceryItemTileState extends State<GroceryItemTile> {
  void decrementUnit() {
    if (widget.unit > 0) {
      // Only decrement if unit is greater than 0
      setState(() {
        widget.unit--;
      });
    }
  }

  void incrementUnit() {
    setState(() {
      widget.unit++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                  padding: EdgeInsets.all(7),
                  margin: EdgeInsets.all(7),
                  width: 100,
                  decoration: BoxDecoration(
                    //color: const Color(0xffD59462),
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "\$ ${widget.price} Per Unit",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        decrementUnit();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          //color: Color(0xffD59462),
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
                          //color: Color(0xffD59462),
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
                          //color: Color(0xffD59462),
                           color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(CupertinoIcons.plus),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class GroceryItemTile extends StatelessWidget {
//   final String name;
//   int unit;
//   final String price;
//   final String image;
//
//   GroceryItemTile(
//       {super.key,
//       required this.name,
//       this.unit = 0,
//       required this.price,
//       required this.image});
//
//   void decrementUnit() {
//     if (unit > 0) {
//       // Only decrement if unit is greater than 0
//       unit--;
//     }
//   }
//   void incrimentUnit(){
//     unit++;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//       children: [
//         Image.asset(
//           image,
//           height: 100,
//         ),
//         Text(name),
//         SizedBox(
//           height: 5,
//         ),
//         Container(
//           padding: EdgeInsets.all(7),
//           margin: EdgeInsets.all(7),
//           width: 60,
//           decoration: BoxDecoration(
//             color: const Color(0xff7c94b6),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             "\$ " + price + " \nper unit",
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             InkWell(
//               onTap: () {decrementUnit();print("$unit");},
//               child: Container(
//                 padding: EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: Colors.brown,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Icon(CupertinoIcons.minus),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 5),
//               child: Text(
//                 "$unit",
//                 style: TextStyle(
//                   color: Colors.brown,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {incrimentUnit();},
//               child: Container(
//                 padding: EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: Colors.brown,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Icon(CupertinoIcons.plus),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }
// }
