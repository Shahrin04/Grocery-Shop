import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/db/users.dart';
import 'package:grocery_app/model/user.dart';
import 'package:toast/toast.dart';


class AuthServices {

  UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromUserCredential(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges()
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromUserCredential);
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String mobile) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      //writing data in realtime database
      _userService.createUser({
        'email': email,
        'password': password,
        'name': name,
        'mobile': mobile,
        'id': _auth.currentUser.uid,
      }).catchError((e) => print(e.toString()));

      return _userFromUserCredential(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signIn with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signOut
  Future signOut() async{
    try{
      await _auth.signOut();
    }catch (e){
      print('signOut Error: ${e.toString()}');
      return null;
    }

  }

}
