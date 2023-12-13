import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Pay.dart';

class Deli extends StatefulWidget {
  static const String id = "Deli";

  @override
  State<Deli> createState() => _DeliState();
}

class _DeliState extends State<Deli> {
  TextEditingController _controller = TextEditingController();
  Color containerColor = Colors.transparent; // Initial color
  bool isContainerVisible = true;
  String select = "select the time of delivery";
  String phone = '';
  String prefix = '';
  List<String> times = [
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00"
  ];
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
            color: Colors.orange[200],
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
              color: Colors.orange,
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
    // Check if the DropdownButton is selected
    if (select == "select the time of delivery") {
      return false;
    }

    // Check if the TextField is completed
    if (_controller.text.isEmpty) {
      return false;
    }

    // Check if the Autocomplete is completed
    if (searchController.text.isEmpty) {
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
                    image: AssetImage("images/Super.avif"), fit: BoxFit.cover),
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
                color: Colors.orange,
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
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 200.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                _controller.addListener(() {
                                  String enteredText = _controller.text;
                                  if (enteredText.length >= 3) {
                                    String firstTwoDigits =
                                        enteredText.substring(0, 3);
                                    if (firstTwoDigits != '050' &&
                                        firstTwoDigits != '052' &&
                                        firstTwoDigits != '053' &&
                                        firstTwoDigits != '054') {
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
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[200],
                                    borderRadius: BorderRadius.circular(60.0),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: TextField(
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
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.orange[200],
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
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton<String>(
                        onChanged: (value) {
                          setState(
                            () {
                              select = value!;
                              showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("See You"),
                                      content: Text(
                                          "your chooice is that the delivery will came to your house at the " +
                                              select +
                                              " are you sure?"),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('Disable'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            //here i need to delete the
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('Enable'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            //here to add the navigator to the home page
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        },
                        hint: Text(
                          select,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        dropdownColor: Colors.orange,
                        elevation: 8,
                        items: times.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildAutocomplete(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Entered Phone Number: $phone"); // check
                      if (isFormCompleted()) {
                        // Navigate to pay.id page
                        Navigator.pushNamed(context, Pay.id);
                      } else {
                        // Show a popup message that some details are incomplete
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Incomplete Details"),
                              content:
                                  Text("Please fill in all required fields."),
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
                      }
                    },
                    child: Text('Check Completion'),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
