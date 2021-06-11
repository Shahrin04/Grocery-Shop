import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/db/users.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:grocery_app/services/auth.dart';
import 'package:grocery_app/wrapper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthServices _authServices = AuthServices();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserService _userService = UserService();

  final _profileFormKey = GlobalKey<FormState>();
  TextEditingController _profileName = TextEditingController();
  TextEditingController _profileMobile = TextEditingController();
  TextEditingController _profileAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
          //centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: () async {
                  _authServices.signOut();
                      // .whenComplete(() =>
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => Wrapper())));
                  // .then((value) =>
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LoginPage())));
                  //Navigator.of(context, rootNavigator: true).pop(context);
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(fontSize: 15)),
                      controller: _profileName,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Write your Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(fontSize: 15)),
                      controller: _profileMobile,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Mobile Number';
                        } else if (value.length < 11) {
                          return 'Please enter all Numbers';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(fontSize: 15)),
                      controller: _profileAddress,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Write your Address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_profileFormKey.currentState.validate()) {
                          _userService.updateUser({
                            'name': _profileName.text,
                            'mobile': _profileMobile.text,
                            'address': _profileAddress.text,
                            'id': _auth.currentUser.uid
                          });
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wrapper(0)));
                      },
                      color: Colors.green,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
