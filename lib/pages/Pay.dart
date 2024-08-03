import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'deliveryPage.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});
  static const String id = "pay";

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool showBackView = false;

  //user pay
  void UserPay() {
    if (formKey.currentState!.validate()) {
      //show message if the form valid
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Confirm Payment"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("Cart Number:  $cardNumber"),
                      Text("Expiry Date:  $expiryDate"),
                      Text("Card Holder Name:  $cardHolderName"),
                    ],
                  ),
                ),
                actions: [
                  //cancle botton
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancle")),
                  //yes botton
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Deli.id);
                      },
                      child: Text("yes"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Payment"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //credit cart
            CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: showBackView,
                onCreditCardWidgetChange: (p0) {}),
            //credit cart form
            CreditCardForm(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                onCreditCardModelChange: (data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                  });
                },
                formKey: formKey),
            // Spacer(),
            SizedBox(
              height: 90,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800], fixedSize: Size(350, 50)),
              onPressed: () {
                UserPay();
              },
              child: Text(
                'Pay Now',
                style: TextStyle(color: Colors.white),
              ),
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
