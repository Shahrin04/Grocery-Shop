import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/pages/sign_up.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/services/auth.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _authId = FirebaseAuth.instance;
  final AuthServices _auth = AuthServices();
  final _loginFormKey = GlobalKey<FormState>();
  String error = '';

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  bool hidePass = true;
  bool passEye = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          children: [
            Image.asset('assets/images/back.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
            Container(
                color: Colors.black.withOpacity(0.6),
                width: double.infinity,
                height: double.infinity),
            Container(
              padding: EdgeInsets.only(top: 80),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/logo.png',
                  fit: BoxFit.fill, width: 200, height: 150),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 270.0),
                child: Center(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 0.2,
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.lightGreen[700],
                                    )),
                                controller: _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regExp = RegExp(pattern);

                                    if (!regExp.hasMatch(value))
                                      return ' Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            elevation: 0.2,
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          icon: Icon(
                                            Icons.lock,
                                            color: Colors.lightGreen[700],
                                          )),
                                      controller: _passwordTextController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: hidePass,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      flex: -1,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.grey[700],
                                          ),
                                          onPressed: () {
                                            if (passEye) {
                                              setState(() {
                                                hidePass = false;
                                                passEye = false;
                                              });
                                            } else if (!passEye) {
                                              setState(() {
                                                hidePass = true;
                                                passEye = true;
                                              });
                                            }
                                          })),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                          child: Material(
                              elevation: 0.2,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.green,
                              child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if (_loginFormKey.currentState.validate()) {
                                      dynamic result = _auth
                                          .signInWithEmailAndPassword(
                                              _emailTextController.text,
                                              _passwordTextController.text)
                                          .whenComplete(() {
                                        if (_authId.currentUser.uid != null) {
                                          Toast.show(
                                            'Signed In Successfully',
                                            context,
                                            duration: 2,
                                            backgroundColor:
                                                const Color(0xFF689F38),
                                          );
                                        }
                                      });
                                      //     .whenComplete(() {
                                      //   if (_authId.currentUser.uid == null) {
                                      //     Toast.show("Sign In Failed", context,
                                      //         duration: 3,
                                      //         backgroundColor:
                                      //             const Color(0xFF689F38),
                                      //         gravity: Toast.BOTTOM);
                                      //   } else {
                                      //     Navigator.pushReplacement(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 StartUpPage())).then(
                                      //         (value) => Toast.show(
                                      //             "Signed In Successfully",
                                      //             context,
                                      //             duration: 3,
                                      //             backgroundColor:
                                      //                 const Color(0xFF689F38),
                                      //             gravity: Toast.BOTTOM));
                                      //   }
                                      // });
                                      // .then((value) =>
                                      //     Navigator.pushReplacement(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 StartUpPage())));

                                      if (result == null) {
                                        Toast.show(
                                            'No user found with this credential',
                                            context,
                                            duration: 3);
                                        // setState(() {
                                        //   error =
                                        //       'Couldn\'t SignIn with this credential';
                                        // });
                                      }
                                    }
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an account?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                                Text(' SignUp',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 57)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
