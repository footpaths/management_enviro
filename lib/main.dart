import 'package:environmental_management/home.dart';
import 'package:environmental_management/report.dart';
import 'package:environmental_management/second_page.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'bottom_nav/fancy_bottom_navigation.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fancy Bottom Navigation"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(

          child: _getPage(currentPage)

        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.search,
              title: "Search",
              onclick: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SecondPage()))),
          TabData(iconData: Icons.person, title: "Basket")
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),

    );
  }

  _getPage(int page) {
    print('cu'+currentPage.toString());
    switch (page) {
      case 0:
        return home();
      case 1:
        return  report();
      case 2:
        return  report();
      default:
        return  report();
    }
  }
}
