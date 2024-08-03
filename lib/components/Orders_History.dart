import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({super.key});
  static const String id = 'OrdersHistory';

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  List<String> orderIds = [];
  bool isLoading = true;
  bool showCartDetails = false;
  Map<String, dynamic>? selectedOrder;

  @override
  void initState() {
    super.initState();
    History();
  }

  Future<void> History() async {
    try {
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orders')
              .get();
      //check if there is any orders
      if (ordersSnapshot.docs.isNotEmpty) {
        setState(() {
          orderIds = ordersSnapshot.docs.map((doc) => doc.id).toList();
          print(orderIds);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("no Orders found for the user");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('error fatching order history: $e');
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      // Access Firestore instance and get the specific order document for the current user
      DocumentSnapshot<Map<String, dynamic>> orderDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(orderId)
          .get();
      if (orderDoc.exists) {
        setState(() {
          selectedOrder = orderDoc.data();
          showCartDetails = true;
        });
      } else {
        print("Order not found");
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (orderIds.isEmpty)
                  Center(child: Text('No orders found'))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderIds.length,
                      itemBuilder: (context, index) {
                        String orderId = orderIds[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => fetchOrderDetails(orderId),
                            child: Text(orderId),
                          ),
                        );
                      },
                    ),
                  ),
                if (showCartDetails && selectedOrder != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    showCartDetails = false;
                                  });
                                },
                              ),
                            ),
                            Text('Cart Details:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: selectedOrder!['cartItems'].length,
                                itemBuilder: (context, index) {
                                  final orderItem =
                                      selectedOrder!['cartItems'][index];
                                  final items = orderItem['items'];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ${index + 1}:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: items.length,
                                        itemBuilder: (context, itemIndex) {
                                          final product = items[itemIndex];
                                          return ListTile(
                                            leading: Image.asset(
                                              product['image'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text(product['name']),
                                            subtitle: Text(
                                                'Quantity: ${product['quantity']}'),
                                            trailing: Text(
                                                '\$${product['price'] * product['quantity']}'),
                                          );
                                        },
                                      ),
                                      Divider(),
                                      Divider(),
                                      Text(
                                          'Delivery Date: ${orderItem['deliveryDate'].toDate()}'),
                                      Text(
                                          'Address: ${orderItem['selectedStreet']}'),
                                      Text(
                                          'Delivery Hour: ${orderItem['deliveryTime'].toDate()}'),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );

//Scaffold(
    //   appBar: AppBar(
    //     title: Text('Order History'),
    //   ),
    //   body: isLoading
    //       ? Center(child: CircularProgressIndicator())
    //       : orderIds.isEmpty
    //       ? Center(child: Text('No orders found'))
    //       : ListView.builder(
    //     itemCount: orderIds.length,
    //     itemBuilder: (context, index) {
    //       String orderId = orderIds[index];
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: ElevatedButton(
    //           onPressed: () {
    //             ////////
    //           },
    //           child: Text(orderId),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
