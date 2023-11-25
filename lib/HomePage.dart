import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GroceryItem.dart';
import 'cart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Consumer<Cart>(builder: (context, value, child) {
              return GridView.builder(
                itemCount: value.shopping.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.2,
                ),
                itemBuilder: (context, index) {
                  return GroceryItemTile(
                    name: value.shopping[index][0],
                    unit: 0,
                    price: value.shopping[index][1],
                    image: value.shopping[index][2],
                  );
                },
              );
            })
                //
                )
          ],
        ),
      ),
    );
  }
}
