import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/db/cart_info.dart';
import 'package:grocery_app/pages/confirm_order.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class OrderHistory {
  final BuildContext context;

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('users');

  OrderHistory(this.context);

  createOrderHistory(Map value) {
    String date = value['date'];

    _database
        .child(_auth.currentUser.uid)
        .child('Order History/$date')
        .set(value)
        // .whenComplete(() => Toast.show(
        //     "Order has been taken successfully", context,
        //     duration: 3,backgroundColor: const Color(0xFF689F38), gravity: Toast.BOTTOM))
        .catchError((e) => print(e.toString()));
  }
}
