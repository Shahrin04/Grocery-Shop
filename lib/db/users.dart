import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref = 'users';

  createUser(Map value) {
    String id = value['id'];
    _database
        .reference()
        .child('$ref/$id')
        .set(value)
        .catchError((e) => print(e.toString()));
  }

  updateUser(dynamic value) {
    String id = value['id'];
    _database
        .reference()
        .child('$ref/$id').update(value)
        .catchError((e) => print(e.toString()));
  }
}
