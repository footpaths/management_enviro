import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class report extends StatefulWidget {
  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "vui lòng bấm nút lấy địa chỉ";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Asset> images = List<Asset>();
  String _error;
  bool _validate = false;

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
  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('You clicked on'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Họ tên: '+ _userController.text),
                SizedBox(height: 10),
                new Text('Phone: '+ _phoneController.text),
                SizedBox(height: 10),
                new Text('địa chỉ: '+ _locationMessage),
                SizedBox(height: 10),
                new Text('và file hình ảnh đính kèm'),
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
          width: 300,
          height: 300,
        );
      }),
    );
  }
  checkTextFieldEmptyOrNot(){

    // Creating 3 String Variables.
    String text1,text2,text3 ;

    // Getting Value From Text Field and Store into String Variable
    text1 = _userController.text ;
    text2 = _phoneController.text ;


    // Checking all TextFields.
    if(text1 == '')
    {
      // Put your code here which you want to execute when Text Field is Empty.
      print('Text Field is empty, Please Fill All Data');
      setState(() {
        _userController.text.isEmpty ? _validate = true : _validate = false;
       });


    }else if(text2 == ''){
      setState(() {
        _phoneController.text.isEmpty ? _validate = true : _validate = false;
      });

    }else{

      _showcontent();

    }

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


    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,

              ),
              child: Column(

                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

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

                    margin: const EdgeInsets.only(left: 40,right: 40),
                    child: TextField(
                      controller: _userController,

                      //controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Họ tên',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 40,right: 40),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Số điện thoại',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      ),

                    ),
                  ),
                  SizedBox(height: 10),
                 Container(
                   margin: const EdgeInsets.only(left: 40,right: 40),
                   child: Text(_locationMessage),
                 ),
                  SizedBox(height: 10),
                  Container(
                     margin: const EdgeInsets.only(left: 40,right: 40),
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
                              loadAssets();
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text("up hình ảnh"),
                          ),

                        ],

                      ),

                  ),

                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(left: 40,right: 40),
                    child:  Expanded(
                      child: buildGridView(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 40,right: 40),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        checkTextFieldEmptyOrNot();
                        //_showcontent();
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Gửi báo cáo"),
                    ) ,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );

    /*Scaffold(
      body: Center(
          child: Container(
          padding: EdgeInsets.only(left: 40.0, right: 40.00),
       child: SingleChildScrollView(
         child: ConstrainedBox(

           child: Column(
             mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Container(
                 // A fixed-height child.
                 color: const Color(0xffeeee00), // Yellow
                 height: 120.0,
                 alignment: Alignment.center,
                 child: const Text('Fixed Height Content'),
               ),
               Container(
                 // Another fixed-height child.
                 color: const Color(0xff008000), // Green
                 height: 120.0,
                 alignment: Alignment.center,
                 child: const Text('Fixed Height Content'),
               ),
             ],
           ),
         ),
       ),

       */ /* child: Column(
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
loadAssets();
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("up hình ảnh"),
                      ),

                    ],

              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Expanded(
                child: buildGridView(),
              ),
            )
          ],
        ),*/ /*
      )),
    );*/
  }
}
