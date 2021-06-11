import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementation{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user.uid;
  }

  @override
  Future<String> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


}