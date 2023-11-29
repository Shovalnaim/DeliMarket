import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
          centerTitle: true,
        ),
        body: Consumer<Cart>(builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(2),
                    itemCount: value.items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey,
                          ),
                          child: ListTile(
                            leading: Image.asset(value.items[index][3]),
                            title: Text(value.items[index][0]),
                            subtitle: Text(value.items[index][1].toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                Provider.of<Cart>(context, listen: false)
                                    .removeItem(index);

                              },
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.purple),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Column(
                        children: [Text('Pay Now'),
                         Text("\$ "+value.calculate())],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}
