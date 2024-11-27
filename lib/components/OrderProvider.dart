import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orderItems = [];
  String _totalPrice = '';

  List<Map<String, dynamic>> get orderItems => _orderItems;
  String get totalPrice => _totalPrice;

  void setOrder(List<Map<String, dynamic>> items, String totalPrice) {
    _orderItems = items;
    _totalPrice = totalPrice;
    notifyListeners();
  }
}
