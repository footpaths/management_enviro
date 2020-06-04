import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
//    Navigator.pushNamed(context, "/home");
    Navigator.of(context).pushReplacementNamed('/home');
  }

  static void goToLogin(BuildContext context) {

    Navigator.of(context).pushNamed('/login');

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
  static void goToFullScreen(BuildContext context,String url) {

    Navigator.of(context).pushNamed('/fullScreen',arguments:{'url': url,});

  }
  static void goToDetails(BuildContext context,String name, String timestamp, String phone, String note,
      String address, String typeprocess, bool statusProcess, String individualKey, dynamic images,String personProcess) {

    Navigator.of(context).pushNamed('/details',arguments: {'name': name, 'timestamp':timestamp,'phone': phone,'note': note,'address': address,'typeprocess': typeprocess,'statusProcess': statusProcess,'individualKey': individualKey,'images': images,'personProcess': personProcess});

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
