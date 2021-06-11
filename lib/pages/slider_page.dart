import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/model/user.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/wrapper.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: Container(
            color: Colors.grey[200],
            child: Center(
              child: Container(
                height: 350,
                width: 320,
                child: Carousel(
                  boxFit: BoxFit.fill,
                  showIndicator: true,
                  dotSize: 7,
                  dotIncreasedColor: Colors.lightGreen[700],
                  dotColor: Colors.grey[200],
                  dotBgColor: Colors.white.withOpacity(0.1),
                  indicatorBgPadding: 10,
                  autoplayDuration: Duration(seconds: 4),
                  animationDuration: Duration(milliseconds: 600),
                  animationCurve: Curves.easeInOutQuad,
                  images: [
                    AssetImage('assets/images/slider1.jpg'),
                    AssetImage('assets/images/slider2.jpg'),
                    AssetImage('assets/images/slider3.jpg'),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightGreen[700]),
                      ),
                    );
                  });

              Timer(
                  Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Wrapper(0))));
            },
            backgroundColor: Colors.lightGreen[700],
            elevation: 5,
            label: Text('Start'),
            icon: Icon(Icons.arrow_right_alt_rounded),
          )),
    );
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
