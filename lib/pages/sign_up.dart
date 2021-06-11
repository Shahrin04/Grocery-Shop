import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/db/users.dart';
import 'package:grocery_app/model/user.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/slider_page.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/services/auth.dart';
import 'package:grocery_app/wrapper.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthServices _auth = AuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _signUpFormKey = GlobalKey<FormState>();
  String error = '';

  bool hidePass = true;
  bool passEye = true;

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _mobileTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/reg_back.jpg',
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
                  key: _signUpFormKey,
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
                                  hintText: 'Full Name',
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.lightGreen[700],
                                  )),
                              controller: _nameTextController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  // Toast.show(
                                  //     "Please enter your Full Name", context,
                                  //     duration: 3,backgroundColor: const Color(0xFF689F38), gravity: Toast.BOTTOM);
                                  return 'Please enter your Full Name';
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Mobile Number',
                                  counterText: '',
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.lightGreen[700],
                                  )),
                              controller: _mobileTextController,
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              validator: (value) {
                                if (value.isEmpty) {
                                  // Toast.show(
                                  //     "Please enter your Mobile Number", context,
                                  //     duration: 3,backgroundColor: const Color(0xFF689F38), gravity: Toast.BOTTOM);
                                  return 'Please enter your Mobile Number';
                                } else if (value.length < 11) {
                                  // Toast.show(
                                  //     "Please enter all Numbers", context,
                                  //     duration: 3,backgroundColor: const Color(0xFF689F38), gravity: Toast.BOTTOM);
                                  return 'Please enter all Numbers';
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
                                    // Toast.show(
                                    //     "Please enter a valid email address", context,
                                    //     duration: 3,backgroundColor: const Color(0xFF689F38), gravity: Toast.BOTTOM);
                                    return 'Please enter a valid email address';
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
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: hidePass,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your password';
                                      } else if (value.length < 6) {
                                        return 'Password should be at least 6 characters long';
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
                                  'SignUp',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_signUpFormKey.currentState.validate()) {
                                    dynamic result = _auth
                                        .registerWithEmailAndPassword(
                                            _emailTextController.text,
                                            _passwordTextController.text,
                                            _nameTextController.text,
                                            _mobileTextController.text)
                                        .whenComplete(() =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SliderPage())));

                                    Toast.show(
                                        "Signed Up Successfully", context,
                                        duration: 3,
                                        backgroundColor:
                                            const Color(0xFF689F38),
                                        gravity: Toast.BOTTOM);

                                    if (result == null) {
                                      Toast.show(
                                          "Sign Up Unsuccessful", context,
                                          duration: 3,
                                          backgroundColor:
                                              const Color(0xFF689F38),
                                          gravity: Toast.BOTTOM);
                                    }

                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Wrapper()));
                                  }
                                })),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                              Text(' Login',
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
                        child: Center(
                          child: Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 17)),
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
    );
  }
}

