import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Deli extends StatefulWidget {
  static const String id = "Deli";

  @override
  State<Deli> createState() => _DeliState();
}

class _DeliState extends State<Deli> {
  TextEditingController _controller =
  TextEditingController();
  Color containerColor = Colors.transparent; // Initial color
  bool isContainerVisible = true;
  String select = "select the time of delivery";
  String phone='';
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
  List<Map<String, dynamic>> data = []; //here we have list of the json file
  List<Map<String, dynamic>> filteredData =
  []; // here we have just the streets in eilat city
  TextEditingController searchController =
  TextEditingController(); //here is what the user write to search


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    //this function reead the json file
    final response = await http.get(
      Uri.parse(
          'https://raw.githubusercontent.com/GabMic/israeli-cities-and-streets-list/master/israeli_street_and_cities_names.json'),
    );

    if (response.statusCode == 200) {
      // id everything is ok
      Map<String, dynamic> jsonData = jsonDecode(response
          .body); // all the json file enter to Map with the key and value for exmple:"city_name":"אילת"

      // Assuming that your JSON structure has a key like 'streets' that contains the list
      List<dynamic> dataList = jsonData['streets'];

      setState(() {
        data = List<Map<String, dynamic>>.from(dataList);
        // Initially, filter data to include only streets in Eilat
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
    //in this func the user enter strret name and search him from the result in filteredData list
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
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        await Future.delayed(
            Duration(milliseconds: 1)); // Simulate an asynchronous operation
        return filteredData
            .where((item) => item['street_name']!
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()))
            .map<String>((item) => item['street_name']! as String)
            .toList();
      },
      onSelected: (String selectedOption) {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
            children: [
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
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                            borderSide: BorderSide.none, // Remove border
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          hintText: "Phone",
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding

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
                      // DropdownButton added below the TextField
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color:
                            Colors.orange[200], // Set the background color here
                            borderRadius: BorderRadius.circular(
                                20.0), // Optional: Add border radius
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
                          // Now you can access the entered phone number in enteredPhoneNumber variable
                          print("Entered Phone Number: $phone");
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




