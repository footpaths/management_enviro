import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
//    Navigator.pushNamed(context, "/home");
    Navigator.of(context).pushReplacementNamed('/home');
  }

  static void goToLogin(BuildContext context) {

    Navigator.of(context).pushReplacementNamed('/login');

  }
}
