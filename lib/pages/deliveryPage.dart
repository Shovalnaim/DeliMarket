import 'dart:convert';
//import 'dart:math';
import 'Pay.dart';
import 'order.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:markettest/pages/order.dart';
import 'package:provider/provider.dart';
import '../components/cart.dart';

class UserDetails {
  final String name;
  final String phone;
  final String selectedStreet;
  final TimeOfDay deliveryTime;
  final DateTime deliveryDate;

  UserDetails({
    required this.name,
    required this.phone,
    required this.selectedStreet,
    required this.deliveryTime,
    required this.deliveryDate,
  });
}

class Deli extends StatefulWidget {
  static const String id = "Deli";

  @override
  State<Deli> createState() => _DeliState();
}

class _DeliState extends State<Deli> {
  late UserDetails userDetails;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  late DateTime deliveryDate; //isFormCompleted
  // static final dateFormat = DateFormat('dd/MM/yyyy');
  late TimeOfDay deliveryTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    DateTime nextSelectableDate = currentDate;
    print('Before while loop: nextSelectableDate = $nextSelectableDate');
    // Find the next available date excluding Fridays and Saturdays
    while (nextSelectableDate.weekday == DateTime.friday ||
        nextSelectableDate.weekday == DateTime.saturday) {
      print('Inside while loop: nextSelectableDate = $nextSelectableDate');
      nextSelectableDate = nextSelectableDate.add(Duration(days: 1));
    }
    print('After while loop: nextSelectableDate = $nextSelectableDate');
    // Set the last selectable date to be 7 weekdays after the current date
    DateTime lastSelectableDate = nextSelectableDate.add(Duration(days: 7));
    print('Before showDatePicker'); // Add this print statement
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nextSelectableDate,
      firstDate: nextSelectableDate,
      lastDate: lastSelectableDate,
      selectableDayPredicate: (DateTime day) =>
          day.weekday != DateTime.friday && day.weekday != DateTime.saturday,
    );
    print('After showDatePicker'); // Add this print statement
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deliveryDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // Checking if the selected date is the current date (ignoring time)
    bool isCurrentDate = selectedDate != null &&
        selectedDate!.year == DateTime.now().year &&
        selectedDate!.month == DateTime.now().month &&
        selectedDate!.day == DateTime.now().day;

    // debug
    print("isCurrentDate: $isCurrentDate");

    // Initialize time in "currentTime" variable of the selected date
    final TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay initialTime;

    if (isCurrentDate) {
      // If it's the current date, set the initial time to the current time + 2 hours
      initialTime = currentTime.replacing(hour: currentTime.hour + 2);
      print("initTime: " +
          initialTime.toString()); //מראה שעה קודם כאילו שעון חורף
      // Limit the initial time to be within the range of 10 am to 6 pm
      if (initialTime.hour < 10) {
        initialTime = initialTime.replacing(hour: 10);
      } else if (initialTime.hour >= 18) {
        initialTime = TimeOfDay(hour: 17, minute: 59); // 6 pm
      }
    } else {
      // If it's another date, set the initial time to 10:00 AM
      initialTime = TimeOfDay(hour: 10, minute: 00);
    }

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      bool isValidTime = true;

      if (picked.hour < 10 ||
          picked.hour >= 18 ||
          (picked.hour == 18 && picked.minute > 0)) {
        isValidTime = false;
      } else if (isCurrentDate &&
          (picked.hour < initialTime.hour ||
              (picked.hour == initialTime.hour &&
                  picked.minute < initialTime.minute))) {
        // Check if the picked time is earlier than the initial time on the current date
        isValidTime = false;
      }

      if (!isValidTime) {
        // Show an alert or message to inform the user about the valid time range
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Time'),
              content: Text(
                  'Please choose a time between 10:00 AM and 6:00 PM. or then you choose hour that is invalide'),
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
        // Update the selected time if it's within the allowed range
        setState(() {
          selectedTime = picked;
          deliveryTime = picked;
          print("deliveryTime to string: " +
              deliveryTime.toString() +
              " selectedTime is: " +
              selectedTime.toString());
        });
      }
    }
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _Textname = TextEditingController();
  Color containerColor = Colors.transparent; // Initial color
  bool isContainerVisible = true;
  bool isVisible = true;
  // String select = "select the time of delivery";
  String phone = '';
  String prefix = '';

  List<String> pre = [
    "050",
    "052",
    "053",
    "054",
  ];

  List<Map<String, dynamic>> data = []; // List containing the JSON data
  List<Map<String, dynamic>> filteredData = []; // Filtered data for Eilat
  TextEditingController searchController =
      TextEditingController(); // Controller for the search street field

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data from the provided JSON file
    final response = await http.get(
      Uri.parse(
          'https://raw.githubusercontent.com/GabMic/israeli-cities-and-streets-list/master/israeli_street_and_cities_names.json'),
    );


    if (response.statusCode == 200) {
      // If the request is successful
      Map<String, dynamic> jsonData = jsonDecode(response
          .body); //  Extract the list of streets from the JSON data, for exmple:"city_name":"אילת"

      // Assuming that your JSON structure has a key like 'streets' that contains the list
      List<dynamic> dataList = jsonData['streets'];

      setState(() {
        data = List<Map<String, dynamic>>.from(dataList);
        // Update the data and filteredData lists
        filteredData = data
            .where((item) =>
                item['city_name'] != null &&
                item['city_name'].toLowerCase() == 'אילת')
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterList(String query) {
    // Filter the data based on the user's input
    setState(() {
      filteredData = data
          .where((item) =>
              item['city_name'] != null &&
              item['city_name'].toLowerCase() == 'אילת' &&
              item['street_name'] != null &&
              item['street_name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Autocomplete<String> buildAutocomplete() {
    //This function returns an Autocomplete widget for street names.
    // It's designed to help users easily find and select their street from a list of suggestions.
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        await Future.delayed(Duration(milliseconds: 1));
        return filteredData
            .where((item) => item['street_name']!
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .map<String>((item) => item['street_name']! as String)
            .toList();
      },
      onSelected: (String selectedOption) {
        //this callback is triggered when the user selects a street from the suggestion list.
        // It updates the searchController with the selected street name,
        // clears the filteredData, and sets isContainerVisible to false
        setState(() {
          searchController.text = selectedOption;
          filteredData.clear();
          isContainerVisible = false;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        //This part specifies the visual representation of the input field.
        // It's a styled text field inside a container,
        // where user input is used to filter the suggestion list through the filterList function.
        return Container(
          height: 50,
          decoration: BoxDecoration(
           
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black),
          ),
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onChanged: (value) {
              filterList(value);
            },
            onSubmitted: (value) {
              onFieldSubmitted();
            },
            decoration: InputDecoration(
              hintText: 'Search by street',
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // Remove border
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        //This part defines how Autocomplete generates its suggestion list.
        // It filters the filteredData list based on the user's input (textEditingValue.text).
        // It returns a list of street names that contain the input substring.

        //This part defines the visual representation of the suggestion list.
        // It's a container with a list of ListTile widgets, each representing a street name option.
        // The onSelected callback is triggered when a user taps on a suggestion.
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/backgroundthree.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                      0.5), // Adjust the opacity value (0.0 to 1.0)
                  BlendMode.dstATop,
                ),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  bool isFormCompleted() {
    // Check if the TextField (name) is completed-
    if (_Textname.text.isEmpty) {
      print(_Textname.text);
      return false;
    }
    // Check if the TextField (phone) is completed
    if (_controller.text.isEmpty) {
      print(_controller.text);
      return false;
    }
    // // Check if the DropdownButton is selected
    // if (select == "select the time of delivery") {
    //   return false;
    // }
    // Check if the Autocomplete is completed
    if (searchController.text.isEmpty) {
      print(searchController.text);
      return false;
    }
    if (deliveryDate == null || deliveryTime == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/backgroundthree.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: Stack(
              children: [
                Container(
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
                  child: Center(
                    child: Text(
                      'Delivery Page',
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
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
                          ),
                          onPressed: () {
                            // Navigate back when the back button is pressed
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 250.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: _Textname,
                        decoration: InputDecoration(
                          filled: false,
                          //fillColor: Colors.orange[200],
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: "Name",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                _controller.addListener(() {
                                  String enteredText = _controller.text;
                                  if (enteredText.length >= 3) {
                                    String firstThreeDigits =
                                        enteredText.substring(0, 3);
                                    if (firstThreeDigits != '050' &&
                                        firstThreeDigits != '052' &&
                                        firstThreeDigits != '053' &&
                                        firstThreeDigits != '054') {
                                      // Clear the text and show an error message
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                              'Invalid phone number - enter just the two number of prefix without the first zero',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      _controller.clear();
                                    }
                                  }
                                });
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  //height: 50,
                                  //width: 150,
                                  decoration: BoxDecoration(
                                    //  color: Colors.orange[200],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: false,

                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide.none, // Remove border
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      hintText: "Phone",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0), // Adjust padding
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: _controller,
                                    onChanged: (value) {
                                      setState(() {
                                        // Update the phone variable
                                        phone = value;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.date_range),
                              SizedBox(width: 8),
                              selectedDate != null
                                  ? Text(
                                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      "Select Date",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(width: 8),
                              selectedTime != null
                                  ? Text(
                                      "${selectedTime!.hour}:${selectedTime!.minute}",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      "Select Time",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildAutocomplete(),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      if (isFormCompleted()) {
                        userDetails = UserDetails(
                          name: _Textname.text,
                          phone: phone,
                          selectedStreet: searchController.text,
                          deliveryTime: deliveryTime,
                          deliveryDate: deliveryDate,
                        );

                        // Show a modal bottom sheet with the order details
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Order Details',
                                      style: TextStyle(fontSize: 18.0)),
                                  SizedBox(height: 16.0),
                                  // Display order details in the modal
                                  Text('Name: ${userDetails.name}'),
                                  Text('Phone: ${userDetails.phone}'),
                                  Text(
                                      'Selected Street: ${userDetails.selectedStreet}'),
                                  Text(
                                      'Delivery Time: ${userDetails.deliveryTime.format(context)}'),
                                  Text(
                                      'Delivery Date: ${DateFormat('dd/MM/yyyy').format(deliveryDate)}'),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            processOrder();
                                            Navigator.pushNamed(context,
                                                Pay.id); //החלפתי אתFinalOrder דף
                                          },
                                          child: Text('Continue to Payment',
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Edit'),
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(200, 40)),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        // Show a popup message that some details are incomplete
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Incomplete Details'),
                              content:
                                  Text('Please fill in all required fields.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("check complete clicked");
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Check Completion',
                        style: TextStyle(color: Colors.black)),
                  )

                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }


  Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    // Format the DateTime object to a string in the desired format
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);

    // Parse the formatted date string back to a DateTime object
    DateTime parsedDate = DateFormat('MMMM dd, yyyy').parse(formattedDate);

    // Convert the DateTime object to a Timestamp
    return Timestamp.fromDate(parsedDate);
  }



  Timestamp _timeOfDayToTimestamp(TimeOfDay timeOfDay, DateTime dateTime) {
    // Construct the combined DateTime object using the selected date and time
    DateTime combinedDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    print("combinedDateTime: " + combinedDateTime.toString());
    // Subtract 2 hours from combinedDateTime
    combinedDateTime = combinedDateTime.subtract(Duration(hours: 2));
    // Convert the combined DateTime object to a Timestamp
    return Timestamp.fromDate(combinedDateTime);
  }

// Function to process the order
  Future<void> processOrder() async {
    // Accessing the Firebase Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Create a reference to the current user's 'orders' subcollection
      CollectionReference userOrdersCollection = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders');

      // Use the current date as the document ID for the order
      String orderDate = DateTime.now().toString().substring(0, 10);

      // Create a list to store the cart items data
      List<Map<String, dynamic>> cartItemsData = [];
      for (List<dynamic> item
          in Provider.of<Cart>(context, listen: false).items) {
        cartItemsData.add({
          'name': item[0],
          'quantity': item[1],
          'price': item[2],
          'image': item[3],
        });
      }

      // Check if the 'orders' collection exists
      DocumentReference userDocRef = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Check if the order document for the current date exists
        DocumentSnapshot orderDoc =
            await userOrdersCollection.doc(orderDate).get();

        if (orderDoc.exists) {
          // If the document exists, update the array of cart items
          await userOrdersCollection.doc(orderDate).update({
            'cartItems': FieldValue.arrayUnion([
              {
                'name': userDetails.name,
                'phone': userDetails.phone,
                'selectedStreet': userDetails.selectedStreet,
                'deliveryTime':
                    _timeOfDayToTimestamp(deliveryTime, deliveryDate),

                'deliveryDate': _dateTimeToTimestamp(userDetails.deliveryDate),
                'items': cartItemsData,
              }
            ]),
          });
        } else {
          // If the document does not exist, create it and add the array of cart items
          await userOrdersCollection.doc(orderDate).set({
            'cartItems': [
              {
                'name': userDetails.name,
                'phone': userDetails.phone,
                'selectedStreet': userDetails.selectedStreet,
                'deliveryTime':
                    _timeOfDayToTimestamp(deliveryTime, deliveryDate),
                'deliveryDate': _dateTimeToTimestamp(userDetails.deliveryDate),
                'items': cartItemsData,
              }
            ],
          });
        }
      } else {
        // If the 'orders' collection does not exist, create it and add the document
        await userOrdersCollection.doc(orderDate).set({
          'cartItems': [
            {
              'name': userDetails.name,
              'phone': userDetails.phone,
              'selectedStreet': userDetails.selectedStreet,
              'deliveryTime': _timeOfDayToTimestamp(deliveryTime, deliveryDate),
              'deliveryDate': _dateTimeToTimestamp(userDetails.deliveryDate),
              'items': cartItemsData,
            }
          ],
        });
      }

      // Call the function to schedule the notification
      await scheduleNotificationForDelivery(
          deliveryTime, deliveryDate, userDetails.name);
      print("scheduleNotificationForDelivery-> deliveryTime: " +
          deliveryTime.toString() +
          " deliveryDate: " +
          deliveryDate.toString() +
          " userDetails.name: " +
          userDetails.name);
     } catch (e) {
      print('Error adding order: $e');
      // Handle the error as needed
     }
   }
  Future<void> scheduleNotificationForDelivery(
      TimeOfDay deliveryTime, DateTime deliveryDate, String userName) async {
    // Combine the delivery date and time
    DateTime scheduledDateTime = DateTime(
      deliveryDate.year,
      deliveryDate.month,
      deliveryDate.day,
      deliveryTime.hour,
      deliveryTime.minute,
    ).subtract(const Duration(hours: 2)).toUtc();

    print("Scheduled DateTime (before saving): $scheduledDateTime");

    // Get the current user ID (you need to be logged in for this to work)
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the user's notifications collection
    var scheduledNotificationsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('scheduled_notifications');

    // Check if any document exists in the collection
    QuerySnapshot querySnapshot = await scheduledNotificationsCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      // A document exists, get the first document ID and update it
      String documentId = querySnapshot.docs.first.id; // Get the first document
      await scheduledNotificationsCollection.doc(documentId).set({
        'userName': userName,
        'scheduledTime': scheduledDateTime,
      });
      print("Updated existing notification document with ID: $documentId");
    } else {
      // No document exists, create a new one
      await scheduledNotificationsCollection.add({
        'userName': userName,
        'scheduledTime': scheduledDateTime,
      });
      print("Created a new notification document.");
    }
   }
   ///didn't finish this function code
    // Cloud Function listening to this 'scheduled_notifications' collection
    // and send the FCM notification at the scheduled time

}
