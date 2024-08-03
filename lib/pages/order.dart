import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markettest/components/settings.dart';
import 'package:markettest/HomePage.dart';
import 'package:markettest/pages/Auth/Login_page.dart';
import 'package:markettest/pages/timer.dart';
import 'package:provider/provider.dart';
import '../components/cart.dart';

class FinalOrder extends StatefulWidget {
  static String id = "order";


  const FinalOrder({super.key});

  @override
  State<FinalOrder> createState() => _FinalOrderState();
}

class _FinalOrderState extends State<FinalOrder> {
  // final String startLocation='ששת הימים 310,אילת,ישראל'; // Starting point of the route
  // final String endLocation=""; // Ending point of the route
  // final String apiKey=''; // MapQuest API Key
  Duration initialDuration = Duration(); // Variable to store initial duration

  String userName = '';
  String userPhone = '';
  Timestamp? DateOrder;
  Timestamp? deliveryTime;
  late DateTime deadline;
  String Address = '';
  String deliveryDateText = '';
  String deliveryTimeText = '';

  bool showCartDetails = false; // משתנה לשליטה בהצגת החלון

  //initialDuration: 7:57:45.896901
  // I/flutter (16067): Time difference: 7 hours and 57 minutes
  // I/flutter (16067): doc id: 2024-05-28
  // I/flutter (16067): deadlineeeee: 2024-05-28 11:00:00.000Z
  // I/flutter (16067): wid.deadlineee: 2024-05-28 11:00:00.000Z
  // I/flutter (16067): duration: 7:57:45.000000

  @override
  void initState() {
    super.initState();
    // Call function to fetch user details when the widget initializes
    fetchUserDetails();
    CalculateTime();
  }

  // Future<void> CalculateTime() async {
  //   DateTime now = DateTime.now();
  //
  //   try {
  //     // Access Firestore instance and query the orders collection
  //     QuerySnapshot<Map<String, dynamic>> orderSnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .collection('orders')
  //             .where(FieldPath.documentId,
  //                 isEqualTo: DateTime.now().toString().substring(0, 10))
  //             .get();
  //     // Access Firestore instance and query the orders collection
  //
  //     Check if there are any orders
  //     if (orderSnapshot.docs.isNotEmpty) {
  //       print(orderSnapshot);
  //       // Get the first document (latest order)
  //       DocumentSnapshot<Map<String, dynamic>> latestOrderDoc =
  //           orderSnapshot.docs.first;
  //
  //
  //         Timestamp deliveryTimeTimestamp =
  //             latestOrderDoc.data()?['deliveryTime'];
  //
  //           DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();
  //
  //           // Add 3 hours to deliveryTimeUTC
  //           DateTime deliveryTimeWithOffset =
  //           deliveryTimeUTC.add(Duration(hours: 3));
  //
  //           // Calculate time difference
  //           Duration difference = deliveryTimeWithOffset.difference(now);
  //           // Convert the difference to a human-readable format
  //           int hours = difference.inHours;
  //           int minutes = difference.inMinutes.remainder(60);
  //           String timeDifference = '$hours hours and $minutes minutes';
  //           initialDuration = difference;
  //           print("initialDuration: " + initialDuration.toString());
  //           print('Time difference: $timeDifference');
  //         }
  //
  //       else{
  //        print("orderSnapshot not exist");
  //      }
  //   }
  //      catch (e) {
  //      print('Error fetching latest order details CalculateTime : $e');
  //    }
  // }

  //1
  Future<void> CalculateTime() async {
    DateTime now = DateTime.now();

    try {
      // Access Firestore instance and query the orders collection
      QuerySnapshot<Map<String, dynamic>> orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .where(FieldPath.documentId, isEqualTo: DateTime.now().toString().substring(0, 10))
          .get();

      // Check if there are any orders
      if (orderSnapshot.docs.isNotEmpty) {
        print(orderSnapshot);
        // Get the first document (latest order)
        DocumentSnapshot<Map<String, dynamic>> latestOrderDoc = orderSnapshot.docs.first;

        // Extract the cartItems array from the document
        List<dynamic> cartItems = latestOrderDoc.data()?['cartItems'] ?? [];

        // Check if the cartItems array is not empty
        if (cartItems.isNotEmpty) {
          // Get the first order details from the cartItems array
          //שיניתי ללסט
         // Map<String, dynamic> latestOrderDetails = cartItems.first;
          Map<String, dynamic> latestOrderDetails = cartItems.last;

          // Get the deliveryTime timestamp from the order details
          Timestamp deliveryTimeTimestamp = latestOrderDetails['deliveryTime'];
          DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();

          // Add 3 hours to deliveryTimeUTC
          DateTime deliveryTimeWithOffset = deliveryTimeUTC.add(Duration(hours: 3));

          // Calculate time difference
          Duration difference = deliveryTimeWithOffset.difference(now);
          // Convert the difference to a human-readable format
          int hours = difference.inHours;
          int minutes = difference.inMinutes.remainder(60);
          String timeDifference = '$hours hours and $minutes minutes';
          initialDuration = difference;

          print("initialDuration: " + initialDuration.toString());
          print('Time difference: $timeDifference');
        } else {
          print('No cart items found in the order');
        }
      } else {
        print("orderSnapshot not exist");
      }
    } catch (e) {
      print('Error fetching latest order details CalculateTime : $e');
    }
  }
//כאן זה גרסה קודמת שך CALCULATE
  // Future<void> CalculateTime() async {
  //   DateTime now = DateTime.now();
  //
  //   try {
  //     // Access Firestore instance and query the orders collection
  //     QuerySnapshot<Map<String, dynamic>> orderSnapshot =
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('orders')
  //         .where(FieldPath.documentId,
  //         isEqualTo: DateTime.now().toString().substring(0, 10))
  //         .get();
  //
  //     // Check if there are any orders
  //     if (orderSnapshot.docs.isNotEmpty) {
  //       print(orderSnapshot);
  //       // Get the first document (latest order)
  //       DocumentSnapshot<Map<String, dynamic>> latestOrderDoc =
  //           orderSnapshot.docs.first;
  //
  //
  //       Timestamp deliveryTimeTimestamp =
  //       latestOrderDoc.data()?['deliveryTime'];
  //
  //       DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();
  //
  //       // Add 3 hours to deliveryTimeUTC
  //       DateTime deliveryTimeWithOffset =
  //       deliveryTimeUTC.add(Duration(hours: 3));
  //
  //       // Calculate time difference
  //       Duration difference = deliveryTimeWithOffset.difference(now);
  //       // Convert the difference to a human-readable format
  //       int hours = difference.inHours;
  //       int minutes = difference.inMinutes.remainder(60);
  //       String timeDifference = '$hours hours and $minutes minutes';
  //       initialDuration = difference;
  //       print("initialDuration: " + initialDuration.toString());
  //       print('Time difference: $timeDifference');
  //     }
  //
  //     else{
  //       print("orderSnapshot not exist");
  //     }
  //   }
  //   catch (e) {
  //     print('Error fetching latest order details CalculateTime : $e');
  //   }
  // }
  // Function to fetch user details from Firestore
  Future<void> fetchUserDetails() async {
    try {
      // Access Firestore instance and get document reference
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Extract user details from document snapshot
      if (userDoc.exists) {
        // Fetch latest order details
        await fetchLatestOrderDetails();
        // Calculate time difference after fetching the latest order details
        await CalculateTime();
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  // Function to fetch the latest order details
  Future<void> fetchLatestOrderDetails() async {
    try {
      // Access Firestore instance and query the orders collection
      QuerySnapshot<Map<String, dynamic>> orderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .where(FieldPath.documentId, isEqualTo: DateTime.now().toString().substring(0, 10))
          .get();

      // Check if there are any orders
      if (orderSnapshot.docs.isNotEmpty) {
        // Get the first document (latest order)
        DocumentSnapshot<Map<String, dynamic>> latestOrderDoc = orderSnapshot.docs.first;

        setState(() {
          // Extract the cartItems array from the document
          List<dynamic> cartItems = latestOrderDoc.data()?['cartItems'] ?? [];

          // Check if the cartItems array is not empty
          if (cartItems.isNotEmpty) {
            // Get the first order details from the cartItems array
            // Map<String, dynamic> latestOrderDetails = cartItems.first;
            Map<String, dynamic> latestOrderDetails = cartItems.last;

            // Extract the dateOrder and address from the document ID and document data
            String documentId = latestOrderDoc.id;
            print('doc id: ' + documentId);

            // Get the deliveryDate and deliveryTime timestamps from Firebase
            Timestamp deliveryDateTimestamp = latestOrderDetails['deliveryDate'];
            Timestamp deliveryTimeTimestamp = latestOrderDetails['deliveryTime'];

            // Convert Timestamps to DateTime objects
            DateTime deliveryDate = deliveryDateTimestamp.toDate();
            DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();

            // Add 3 hours to deliveryTimeUTC
            DateTime deliveryTimeWithOffset = deliveryTimeUTC.add(Duration(hours: 3));
            deadline = deliveryTimeWithOffset;
            print("deadlineeeee: " + deadline.toString());

            // Format the deliveryDate and deliveryTime
            String formattedDeliveryDate = DateFormat('MMMM dd, yyyy').format(deliveryDate);
            String formattedDeliveryTime = DateFormat('HH:mm').format(deliveryTimeWithOffset.toLocal());

            // Assign the formatted deliveryDate and deliveryTime to variables
            deliveryDateText = formattedDeliveryDate;
            deliveryTimeText = formattedDeliveryTime;

            // Get other details from Firebase
            userName = latestOrderDetails['name'] ?? '';
            userPhone = latestOrderDetails['phone'] ?? '';
            Address = latestOrderDetails['selectedStreet'] ?? '';
          } else {
            print('No cart items found in the order');
          }
        });
      } else {
        print('No orders found for the user');
      }
    } catch (e) {
      print('Error fetching latest order details: $e');
    }
  }

//   // Function to fetch the latest order details
//   Future<void> fetchLatestOrderDetails() async {
//     try {
//       // Access Firestore instance and query the orders collection
// //התחברות לטבלה של התאריך שבו בוצעה ההזמנה
//       QuerySnapshot<Map<String, dynamic>> orderSnapshot =
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('orders')
//           .where(FieldPath.documentId,
//           isEqualTo: DateTime.now().toString().substring(0, 10))
//           .get();
//
//       // Check if there are any orders
//       if (orderSnapshot.docs.isNotEmpty) {
//
//         // Get the first document (latest order)
//         DocumentSnapshot<Map<String, dynamic>> latestOrderDoc =
//             orderSnapshot.docs.first;
//
//         setState(() {
//           // Extract the dateOrder and address from the document ID and document data
//           String documentId = latestOrderDoc.id;
//           print('doc id: ' + documentId);
//
// // Get the deliveryDate and deliveryTime timestamps from Firebase
//           Timestamp deliveryDateTimestamp =
//           latestOrderDoc.data()?['deliveryDate'];
//           Timestamp deliveryTimeTimestamp =
//           latestOrderDoc.data()?['deliveryTime'];
//
// // Convert Timestamps to DateTime objects
//           DateTime deliveryDate = deliveryDateTimestamp.toDate();
//           DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();
//
//           // Add 3 hours to deliveryTimeUTC
//           DateTime deliveryTimeWithOffset =
//           deliveryTimeUTC.add(Duration(hours: 3));
//           deadline = deliveryTimeWithOffset;
//           print("deadlineeeee: " + deadline.toString());
// // Format the deliveryDate and deliveryTime
//           String formattedDeliveryDate =
//           DateFormat('MMMM dd, yyyy').format(deliveryDate);
//           String formattedDeliveryTime =
//           DateFormat('HH:mm').format(deliveryTimeWithOffset.toLocal());
//
// // Assign the formatted deliveryDate and deliveryTime to variables
//           deliveryDateText = formattedDeliveryDate;
//           deliveryTimeText = formattedDeliveryTime;
//
// // Get other details from Firebase
//           userName = latestOrderDoc.data()?['name'] ?? '';
//           userPhone = latestOrderDoc.data()?['phone'] ?? '';
//           Address = latestOrderDoc.data()?['selectedStreet'] ?? '';
//
//         });
//       } else {
//         print('No orders found for the user');
//       }
//     } catch (e) {
//       print('Error fetching latest order details: $e');
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Order'),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
      //       padding: EdgeInsets.zero,
      //       children: [
      //
      //         SizedBox(
      //           height: 250,
      //         ),
      //         ListTile(
      //           title: Text('My Account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //           onTap: () {
      //             //Navigator.pushNamed(context,Settings.id);
      //
      //           },
      //         ),
      //         Divider(),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         ListTile(
      //           title: Text('Orders History',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //           onTap: () {
      //             // Handle item 1 tap
      //           },
      //         ),
      //         Divider(),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         ListTile(
      //           title: Text('Home Page',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //           onTap: () {
      //             Navigator.pushNamed(context, HomePage.id); //בעיה של גודל עמוד
      //           },
      //         ),
      //         Divider(),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         ListTile(
      //           title: Text('Log Out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //           onTap: () {
      //             Navigator.pushNamed(context, LoginPage.id);
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/backgroundthree.jpg', // Path to your image asset
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5), // Adjust opacity here
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                //כאן המפה עם תמונה של שתי הנקודות של הלקוח ושל הנהג מהעסק
                width: 320,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 2, style: BorderStyle.solid),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Colors.white54, boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]),
                child: Column(
                  children: [
                    Text(
                      'Order Detiles :',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Display user details fetched from Firestore
                    Container(
                        child: Column(children: [
                      Text('Name: $userName'),
                      Text('Phone: $userPhone'),
                      Text('Delivery Date: $deliveryDateText'),
                      Text('Address: $Address'),
                      Text('Delivery Hour: $deliveryTimeText')
                    ])),
                    SizedBox(
                      height: 50,
                    ),
                    timer(
                      deadline: deadline, // Pass deadline as needed

                      textStyle:
                          TextStyle(color: Colors.black), // Example text style
                      initialDuration: initialDuration,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createTextButton(context, 'New Order', 'HomePage'),
                  createTextButton(context, 'See My Order Products', ''),
                  createTextButton(context, 'LogOut', 'LoginPage'),
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Visibility(
              visible: showCartDetails,
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned(
                        child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          showCartDetails = false;
                        });
                      },
                    )),
                    Text('Cart Details:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<Cart>(context).items.length,
                        itemBuilder: (context, index) {
                          final item = Provider.of<Cart>(context).items[index];
                          return ListTile(
                            leading: Image.asset(
                              item[3],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item[0]),
                            subtitle: Text('Quantity: ${item[1]}'),
                            trailing: Text('\$${item[2] * item[1]}'),
                          );
                        }),
                    Divider(),
                    Center(
                      child: Container(
                        child: Column(
                          children: [
                            Text('Delivery Date: $deliveryDateText'),
                            Text('Address: $Address'),
                            Text('Delivery Hour: $deliveryTimeText')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }


Widget createTextButton(BuildContext context, String text, String routeName) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: TextButton(
          onPressed: () {
            if (text == 'New Order') {

              // Clear the cart when starting a new order
              Provider.of<Cart>(context, listen: false).clear();
              // Reset quantities of all products to zero
              Provider.of<Cart>(context, listen: false).resetAllUnitsToZero();

              // Optionally reset any other state variables here
              setState(() {
                userName = '';
                userPhone = '';
                Address = '';
                deliveryDateText = '';
                deliveryTimeText = '';
                //deadline = DateTime.now();
                initialDuration = Duration();
                showCartDetails = false;
                Navigator.pushNamed(context, HomePage.id);
              });
            } else if (routeName.isEmpty) {
              setState(() {
                showCartDetails = true;
              });
            } else {
              Navigator.pushNamed(context, routeName);
            }
          },
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black), // Customize the text style if needed
          ),
         ),
      ),
    );
  }

}
