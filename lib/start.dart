import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Start());
}

class Start extends StatelessWidget {
  static const String id="start";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eilat City Filter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://raw.githubusercontent.com/GabMic/israeli-cities-and-streets-list/master/israeli_street_and_cities_names.json'),
    );


    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Map<String, dynamic>> filterData(String cityName) {
    return data
        .where((item) => item['city_name'] != null && item['city_name'].toLowerCase() == cityName.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eilat City Filter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filterData('אילת').length,
              itemBuilder: (context, index) {
                final result = filterData('אילת')[index];
                return ListTile(
                  title: Text(result['street_name']),
                  subtitle: Text(result['city_name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
