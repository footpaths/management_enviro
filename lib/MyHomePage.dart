import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Constants/Constants.dart';
import 'bottom_nav/fancy_bottom_navigation.dart';
import 'home.dart';

import 'report.dart';


class MyHomePage extends StatefulWidget {
  final bool userName;
  MyHomePage(this.userName);


  @override
  _MyHomePageState createState() => _MyHomePageState(userName);
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey bottomNavigationKey = GlobalKey();

  final bool userName;
  _MyHomePageState(this.userName);

  @override
  Future<void> initState()   {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(child: _getPage(Constants.SUCCESS_MESSAGE)),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home" + userName.toString(),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(0);
              }),
          TabData(
              iconData: Icons.search,
              title: "Search",
//              onclick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()))

          ),
          TabData(iconData: Icons.person, title: "Basket")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            Constants.SUCCESS_MESSAGE = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return home();
      case 1:
        return report();
      case 2:
        return report();
      default:
        return home();
    }
  }
}
