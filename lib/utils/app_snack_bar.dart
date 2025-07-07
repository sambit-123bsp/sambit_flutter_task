import 'package:flutter/material.dart';

class AppSnackBar{

  static void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(color: Colors.white)), backgroundColor: Colors.black),
    );
  }
  static  void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
    );
  }
  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(color: Colors.white),), backgroundColor: Colors.red),
    );
  }

}