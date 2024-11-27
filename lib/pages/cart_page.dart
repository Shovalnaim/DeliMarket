import 'package:flutter/material.dart';
import 'package:markettest/HomePage.dart';
import 'package:provider/provider.dart';
import '../GroceryItem.dart';
import '../components/cart.dart';
import 'Pay.dart';
import 'deliveryPage.dart';

class CartPage extends StatelessWidget {
  static const String id = "cartPage";
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<Cart>(
            builder: (context, value, child) {
      return Stack(children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/backgroundthree.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                      0.7), // Adjust the opacity value (0.0 to 1.0)
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 20.0)],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width,
                  100.0,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.only(top: 15, left: 5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.id);
                  },
                ),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "My Cart",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(2),
                  itemCount: value.items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 60,
                            child: Image.asset(
                              value.items[index][3],
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(value.items[index][0]),
                          subtitle: Text(value.items[index][1].toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {

                              // Reset all units to 0 when the FloatingActionButton is pressed
                              Provider.of<Cart>(context, listen: false).resetUnitToZero(value.items[index][0]);

                              // Trigger rebuild of GroceryItemTile widgets by notifying listeners
                              Provider.of<Cart>(context, listen: false).notifyListeners();
                              Provider.of<Cart>(context, listen: false)
                                  .removeItem(index);
                            },

                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "\$ " + value.calculate(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            "Include delivery",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          //כאן אני רוצה לשמור את כלל הרשימה כדי להכניס אותה לפיירבייס מתחת לתאריך של במשלוח
                          // onPressed: () {
                          // // Access the OrderProvider
                          // var orderProvider = Provider.of<OrderProvider>(
                          //     context,
                          //     listen: false);
                          //
                          // // Prepare the order details
                          // List<Map<String, dynamic>> orderItems = [];
                          // value.items.forEach((item) {
                          //   Map<String, dynamic> orderItem = {
                          //     'image': item[3],
                          //     'productName': item[0],
                          //     'units': item[1].toString(),
                          //   };
                          //   orderItems.add(orderItem);
                          // });
                          //
                          // // Save order to the OrderProvider
                          // orderProvider.setOrder(
                          //     orderItems, value.calculate());

                          // Navigate to the payment page
                          //   Navigator.pushNamed(context, Deli.id);
                          // },
                          onPressed: () {
                            if (value.items.isEmpty) {
                              // Show a popup message that the cart is empty
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Empty Cart'),
                                    content: Text(
                                        'Your cart is empty. Please add items before proceeding.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Navigate to the payment page
                              Navigator.pushNamed(context, Deli.id); //החלפתי את PAY PAGE
                            }
                          },

                          child: Row(
                            children: [
                              Text(
                                'Pay Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ]);
    }));
  }
}
