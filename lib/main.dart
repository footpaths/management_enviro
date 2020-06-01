import 'package:environmental_management/Constants/Constants.dart';
import 'package:environmental_management/MyHomePage.dart';

import 'package:flutter/material.dart';

import 'LoginScreen.dart';
import 'map.dart';
import 'splash_screen.dart';
import 'view/ChoosePageScreen.dart';
//void main() => runApp(MyApp());
var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => MyHomePage(true),
  "/login": (BuildContext context) => LoginScreen(),
  "/choose": (BuildContext context) => ChoosePageScreen(),
  "/map": (BuildContext context) => HomeMapPage(),
};

void main() => runApp(new MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.green, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes));

