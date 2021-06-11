import 'dart:async';
//import 'dart:js';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_app/pages/sign_up.dart';
import 'package:grocery_app/pages/slider_page.dart';
import 'package:grocery_app/services/auth.dart';
import 'package:grocery_app/wrapper.dart';
import 'package:provider/provider.dart';
import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<UserModel>.value(
    value: AuthServices().user,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.lightGreen[700]),
      home: SplashScreen(),
    ),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper(0))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        //width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 150,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SpinKitWave(
                color: Colors.lightGreen[700],
                size: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
