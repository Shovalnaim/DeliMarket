import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'OrderProvider.dart';

class Invoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);

    // Access order data
    var orderItems = orderProvider.orderItems;
    var totalPrice = orderProvider.totalPrice;

    // Use order data in the UI
    // For example:
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Column(
        children: [
          Positioned(top:20,right: 10, child: Column(children: [],), ),
          ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              var item = orderItems[index];
              return ListTile(
                leading: Image.asset(item['image']),
                title: Text(item['productName']),
                subtitle: Text('Units: ${item['units']}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
