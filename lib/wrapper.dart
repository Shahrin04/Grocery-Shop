import 'package:flutter/material.dart';
import 'package:grocery_app/model/user.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/sign_up.dart';
import 'package:grocery_app/pages/startUpPage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  int specialValue = 0;

  Wrapper(this.specialValue);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    //print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      specialValue = 0;
      return LoginPage();
    } else {
      return specialValue==0 ? StartUpPage(0) : StartUpPage(1);
    }

  }
}
