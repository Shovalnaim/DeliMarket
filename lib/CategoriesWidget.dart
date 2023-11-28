import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  static const String id = "category";

  @override
  Widget build(BuildContext context) {
    List<String> imageFileNames = [
      "bread.jpeg",
      "condiments.jpeg",
      "fish.jpeg",
      "fruits.jpeg",
      "meat.jpeg",
      "pasta.jpeg",
      "vegetables.jpeg"
    ];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "see all",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              )
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
            for (String imageName in imageFileNames)
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
                        Navigator.pushNamed(context, "bread");
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset("images/categories/$imageName"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        child: Text(
                          "Item Title",
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
