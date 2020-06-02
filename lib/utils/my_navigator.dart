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
  static void goToPDF(BuildContext context) {

    Navigator.of(context).pushNamed('/pdf');

  }

  static void goToPort(BuildContext context) {
    /*Navigator.of(context).push(
        new PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return  report();
            },
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            }
        )
    );*/
    Navigator.of(context).pushReplacementNamed('/port');

  }
}
