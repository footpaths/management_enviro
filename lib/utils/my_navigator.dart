import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
//    Navigator.pushNamed(context, "/home");
    Navigator.of(context).pushReplacementNamed('/home');
  }

  static void goToLogin(BuildContext context) {

    Navigator.of(context).pushReplacementNamed('/login');

  }
  static void goToChoose(BuildContext context) {

    Navigator.of(context).pushReplacementNamed('/choose');

  }
  static void goToReport(BuildContext context) {

    Navigator.of(context).pushNamed('/map');

  }
}
