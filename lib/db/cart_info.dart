import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CartInfo {
  final BuildContext context;

  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref1 = 'Cart Info';
  String ref2 = 'users';

  CartInfo(this.context);

  createCartInfo(Map value) {
    String id = value['id'];
    String email = value['email'];
    String pid = value['pid'];

    _database
        .reference()
        .child('$ref1/$id/$email/$pid')
        .set(value)
        .whenComplete(() => Toast.show("Product added to Cart", context,
            duration: 3,
            backgroundColor: const Color(0xFF689F38),
            gravity: Toast.BOTTOM))
        .catchError((e) => print(e.toString()));
  }
}
