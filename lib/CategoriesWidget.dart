import 'package:flutter/material.dart';
import 'package:markettest/pages/BreadPage.dart';
import 'package:markettest/pages/FishPage.dart';
import 'package:markettest/pages/Fruits.dart';
import 'package:markettest/pages/Meat.dart';
import 'Condiments.dart';
import 'pages/Pasta.dart';
import 'pages/Vegetables.dart';

class CategoriesWidget extends StatelessWidget {
  static const String id = "category";

  @override
  Widget build(BuildContext context) {
    List<List<String>> images = [
      ["bread","bread.jpeg",BreadPage.id],
      ["condiments","condiments.jpeg",Condiments.id],
      ["fish","fish.jpeg",FishPage.id],
      ["fruits","fruits.jpeg",Fruits.id],
      ["meat","meat.jpeg",Meat.id],
      ["pasta","pasta.jpeg",Pasta.id],
      ["vegetables","vegetables.jpeg",Vegetables.id]
    ];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Text(
                "Category",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          shrinkWrap: true,
          children: [
            for (List<String> image in images)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,image[2]);
                        print("move to : "+image[2]);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset("images/categories/${image[1]}"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        child: Text(
                          //"Item Title",
                          image[0],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        child: Text(
                          "Fresh Fruit - per unit",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        )
      ],
    );
  }
}
