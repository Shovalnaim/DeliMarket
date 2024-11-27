import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:markettest/pages/order.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  bool isLoading = false;
//
  // Declare the necessary variables
  final secureStorage = FlutterSecureStorage();
  late final encrypt.Key encryptKey;
  late final encrypt.IV iv;
  late final encrypt.Encrypter encrypter;
  // Initialize variables in the constructor
  _PayState() {
    encryptKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    iv = encrypt.IV.fromLength(16);
    encrypter = encrypt.Encrypter(encrypt.AES(encryptKey));
  }

  String encryptData(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

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
                      onPressed: () async {
                        // Save payment details to Firestore
                        await savePaymentDetails(
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                        );

                        Navigator.pushNamed(
                            context, FinalOrder.id); //change deli page
                      },
                      child: Text("yes"))
                ],
              ));
    }
  }

  Future<void> savePaymentDetails({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
  }) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's 'payment' document
      DocumentReference paymentDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc('payment');

      // Encrypt the payment details
      String encryptedCardNumber = encryptData(cardNumber);
      String encryptedExpiryDate = encryptData(expiryDate);
      String encryptedCardHolderName = encryptData(cardHolderName);
      String encryptedCvvCode = encryptData(cvvCode);

      // Save the payment details
      await paymentDocRef.set({
        'Card Number': encryptedCardNumber,
        'Expiry Date': encryptedExpiryDate,
        'Card Holder Name': encryptedCardHolderName,
        'CvvCode': encryptedCvvCode,
      });

      print('Payment details saved successfully');
    } catch (e) {
      print('Error saving payment details: $e');

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
          automaticallyImplyLeading: false),
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
