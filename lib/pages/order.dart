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

  @override
  void initState() {
    super.initState();
    // Call function to fetch user details when the widget initializes
    fetchUserDetails();
    CalculateTime();
  }

  Future<void> CalculateTime() async {
    DateTime now = DateTime.now();

    try {
      // Access Firestore instance and query the orders collection
      QuerySnapshot<Map<String, dynamic>> orderSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orders')
              .where(FieldPath.documentId,
                  isEqualTo: DateTime.now().toString().substring(0, 10))
              .get();

      // Check if there are any orders
      if (orderSnapshot.docs.isNotEmpty) {
        print(orderSnapshot);
        // Get the first document (latest order)
        DocumentSnapshot<Map<String, dynamic>> latestOrderDoc =
            orderSnapshot.docs.first;

        // Extract the cartItems array from the document
        List<dynamic> cartItems = latestOrderDoc.data()?['cartItems'] ?? [];

        // Check if the cartItems array is not empty
        if (cartItems.isNotEmpty) {
          // Get the first order details from the cartItems array
          //שיניתי to last
          // Map<String, dynamic> latestOrderDetails = cartItems.first;
          Map<String, dynamic> latestOrderDetails = cartItems.last;

          // Get the deliveryTime timestamp from the order details
          Timestamp deliveryTimeTimestamp = latestOrderDetails['deliveryTime'];
          DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();

          // Add 3 hours to deliveryTimeUTC
          DateTime deliveryTimeWithOffset =
              deliveryTimeUTC.add(Duration(hours: 3));

          // Calculate time difference
          Duration difference = deliveryTimeWithOffset.difference(now);
          // Convert the difference to a readable format
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
      QuerySnapshot<Map<String, dynamic>> orderSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orders')
              .where(FieldPath.documentId,
                  isEqualTo: DateTime.now().toString().substring(0, 10))
              .get();

      // Check if there are any orders
      if (orderSnapshot.docs.isNotEmpty) {
        // Get the first document (latest order)
        DocumentSnapshot<Map<String, dynamic>> latestOrderDoc =
            orderSnapshot.docs.first;

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
            Timestamp deliveryDateTimestamp =
                latestOrderDetails['deliveryDate'];
            Timestamp deliveryTimeTimestamp =
                latestOrderDetails['deliveryTime'];

            // Convert Timestamps to DateTime objects
            DateTime deliveryDate = deliveryDateTimestamp.toDate();
            DateTime deliveryTimeUTC = deliveryTimeTimestamp.toDate().toUtc();

            // Add 3 hours to deliveryTimeUTC
            DateTime deliveryTimeWithOffset =
                deliveryTimeUTC.add(Duration(hours: 3));
            deadline = deliveryTimeWithOffset;
            print("deadlineeeee: " + deadline.toString());

            // Format the deliveryDate and deliveryTime
            String formattedDeliveryDate =
                DateFormat('MMMM dd, yyyy').format(deliveryDate);
            String formattedDeliveryTime =
                DateFormat('HH:mm').format(deliveryTimeWithOffset.toLocal());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Order'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),

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
          SingleChildScrollView(
            child: Column(
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
                    //createTextButton(context, 'New Order', 'HomePage'),
                    createTextButton(context, 'See My Order Products', ''),
                    createTextButton(context, 'LogOut', 'LoginPage'),
                  ],
                )
              ],
            ),
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
          onPressed: () async {
            if (text == 'New Order') {
              try {
                await deletePaymentDetails();

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
                  // Navigator.pushNamed(context, HomePage.id);
                });
                Navigator.pushNamed(context, HomePage.id);
              } catch (e) {
                // Handle any errors here, for example by showing a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete payment details')),
                );
              }
            } else if (text == 'LogOut') {
              try {
                // Call deletePaymentDetails when logging out
                await deletePaymentDetails();

                // Clear the cart when starting a new order
                Provider.of<Cart>(context, listen: false).clear();
                // Reset quantities of all products to zero
                Provider.of<Cart>(context, listen: false).resetAllUnitsToZero();

                // Perform any additional logout logic here, like clearing user data
                Navigator.pushNamed(context, LoginPage.id);
              } catch (e) {
                // Handle any errors here, by showing a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete payment details')),
                );
              }
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
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  //function that delete the card details when the user click on new order or logout , security reason
  Future<void> deletePaymentDetails() async {
    try {
      // Get the current user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Connect to the 'payments' collection and delete the payment document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc('payment')
          .delete();

      print('Payment details deleted successfully');
    } catch (e) {
      // Handle any errors here
      print('Error deleting payment details: $e');
      throw e; // Rethrow the error
    }
  }
}
