import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/pages/HomePage.dart';
import 'package:grocery_app/pages/my_cart.dart';
import 'package:grocery_app/pages/statements.dart';
import 'package:grocery_app/pages/profile.dart';
import 'package:grocery_app/services/auth.dart';

class StartUpPage extends StatefulWidget {
  int specialValue = 0;

  StartUpPage(this.specialValue);

  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex=0;

  final List<Widget> _children = [
    HomePage(),
    MyCart(),
    Statements(),
    Profile(),
  ];


  @override
  void initState() {
    super.initState();
    print(_auth.currentUser.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: widget.specialValue==0 ? _children[_currentIndex] : _children[widget.specialValue],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5.0,
          currentIndex: widget.specialValue==0 ?_currentIndex : widget.specialValue,
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.lightGreen[700],
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          onTap: onTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text('Cart')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Statements')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile')),
          ],
        ),
      ),
    );
  }


  void onTapped(int value) {
    setState(() {
      widget.specialValue==0 ? _currentIndex = value : widget.specialValue=value;
      // if(widget.specialValue==0){
      //   _currentIndex = value;
      // }else{
      //   widget.specialValue=0;
      //   widget.specialValue=value;
      // }
    });
  }


  Future<bool> _onBackPressed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit ?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }
}
