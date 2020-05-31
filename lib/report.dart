import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class report extends StatefulWidget {
  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "Vui lòng bấm nút lấy địa chỉ";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<Asset> images = List<Asset>();
  String _error;
  bool _validate = false;
  bool _validatePhone = false;
  String _dropdownValue = 'One';
//  final databaseReference = FirebaseDatabase.instance.reference();


  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
  void createRecord(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm').format(now);
    var _firebaseRef = FirebaseDatabase().reference().child('chats');
    _firebaseRef.push().set({
      "name": _userController.text,
      "timestamp": formattedDate,
      "phone": _phoneController.text,
      "note": _noteController.text,
      "address": _locationMessage,
      "typeprocess": _dropdownValue,

    });

  }
  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(

          title: new Text('Xác nhận!!!',style: TextStyle(color: Colors.red),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Họ tên: ' + _userController.text),
                SizedBox(height: 10),
                new Text('Phone: ' + _phoneController.text),
                SizedBox(height: 10),
                new Text('địa chỉ: ' + _locationMessage),
                SizedBox(height: 10),
                new Text('Loại xử lý: ' + _dropdownValue),
                SizedBox(height: 10),
                new Text('Ghi chú: ' + _noteController.text),
                SizedBox(height: 10),
                new Text('và ảnh đã chọn'),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Bỏ qua'),
              onPressed: () {

                Navigator.of(context).pop();

              },
            ),
            new FlatButton(
              child: new Text('Đồng ý'),
              onPressed: () {
                createRecord();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );
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
      // print("${first.featureName} : ${first.addressLine}");
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phoneController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Appbar"),
        actions: <Widget>[
          Padding(

              padding: EdgeInsets.only(right: 20.0, bottom: 10.0,top: 10.0),
              child: Container(
                height: 20.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    setState(() {
                      _userController.text.isEmpty ? _validate = true : _validate = false;
                      _phoneController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
                    });

                    if(!_validate && !_validatePhone){
                      _showcontent();
                    }
                    //_showcontent();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Gửi báo cáo"),
                ) ,
              )
          ),

        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Header Container

            //Body Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Thông tin báo cáo',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _userController,

                              //controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Họ tên',
                                errorText:
                                    _validate ? 'Họ tên không được rỗng' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Số điện thoại',
                                errorText:
                                _validatePhone ? 'SĐT không được rỗng' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ghi chú',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("***Vui lòng chọn loại xử lý", style: TextStyle(color: Colors.red),),
                          Container(
                            width: 300.0,
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _dropdownValue,
                              onChanged: (String newValue) {
                                setState(() {
                                  _dropdownValue = newValue;
                                });
                              },
                              items: <String>['One', 'Two', 'Free', 'Four']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Text(_locationMessage, style: TextStyle(color: Colors.red),),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  onPressed: () {
                                    _getCurrentLocation();
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: Text("Lấy địa chỉ"),
                                ),
                                SizedBox(width: 10),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  onPressed: () {
                                    loadAssets();
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: Text("up hình ảnh"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                              child: buildGridView(),

                          )


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );


  }
}
