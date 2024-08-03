import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/**
 * Display an error message in an AlertDialog.
 *
 * This function creates and displays an AlertDialog containing the specified error message.
 *
 * @param {BuildContext} context - The BuildContext for displaying the error message.
 * @param {String} error - The error message to be displayed.
 */
void errorMessage(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(error),
        ),
      );
    },
  );
}
