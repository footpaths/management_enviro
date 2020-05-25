import 'dart:async';
 import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';



class report extends StatefulWidget {
  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "vui lòng bấm nút lấy địa chỉ";
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
  }


  void _getCurrentLocation() async {
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;



    setState(() {
      _locationMessage = "${first.addressLine}";
      _controller.text =_locationMessage;
      // print("${first.featureName} : ${first.addressLine}");
    });
  }


  @override
  Widget build(BuildContext context) {
    _controller.text = '1111111111'; //Set value

    return Scaffold(
      body: Center(
          child: Container(
        padding: EdgeInsets.only(left: 40.0, right: 40.00),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Thông tin báo cáo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(height: 10),
            TextField(
              //controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Họ tên',
              ),

            ),
            SizedBox(height: 10),
            TextField(
              //controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số điện thoại',
              ),

            ),
            SizedBox(height: 10),

            SizedBox(height: 10),
            Text(_locationMessage),
            SizedBox(height: 10),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: () {
                          _getCurrentLocation();
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("Lấy địa chỉ"),
                      ),
                      SizedBox(width: 10),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: () {

                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("up hình ảnh"),
                      ),

                    ],

              ),
            ),
            SizedBox(height: 10),




          ],
        ),
      )),
    );
  }
}
