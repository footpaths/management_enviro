import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:location/location.dart';

class report extends StatefulWidget {

  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {

    Map<String,double> currentlocation  = new Map();
    StreamSubscription<Map<String,double>> locationSubscription;
    Location location = new Location();
    String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          /*  if (currentLocation != null)
              Text("LAT: ${currentLocation.latitude}, LNG: ${currentLocation.longitude}"),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              onPressed: () {
                _getCurrentLocation();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Get location"),
            ),*/

          ],
        ),
        /* child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)),
          onPressed: () {
            _getCurrentLocation();
          },
          color: Colors.red,
          textColor: Colors.white,
       */ /*   child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              if (currentLocation != null)
            Text("LAT: ${currentLocation.latitude}, LNG: ${currentLocation.longitude}"),
          FlatButton(
            child: Text("Get location"),
            onPressed: () {
              _getCurrentLocation();
            },
          )*/ /*


        ),*/
      ),
    );
  }

  _getCurrentLocation() {

  }
}
