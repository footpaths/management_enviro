import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

import 'Constants/Constants.dart';
import 'Constants/icon_image.dart';
import 'picker/camera.dart';
import 'package:image_picker/image_picker.dart';

class report extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  const report({Key key, this.globalKey}) : super(key: key);

  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "Đang lấy địa chỉ..";
//  String imagesAttach = "và không có ảnh được chọn";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
   List<Asset> images = List<Asset>();
   List<ByteData> imagesNew = [];
  List<String> imageUrls = <String>[];
  List<String> listUrls = <String>[];

  String _error;
  bool _validate = false;
  bool _validatePhone = false;
  bool _validateLocation = false;
  bool _validateImage = false;
  bool _statusProcess = false;
  bool _selectImages = false;
  String _dropdownValue = 'Lấn đất';
  int counter = 0;
//  final databaseReference = FirebaseDatabase.instance.reference();
  final picker = ImagePicker();
  File _image;

  List<File> img =  [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
     setState(() {
      _image = File(pickedFile.path);
      img.add(_image);
      print('aaaaaa'+ _image.path);
      counter++;
    });
  }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

  }



 /* Future<void> loadAssets() async {
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
  void openCamera(context) async {
    final image = await CustomCamera.openCamera();

    setState(() {
      _image = image;


      *//*  Uint8List bytes = image.readAsBytesSync();
      imagesNew.add(ByteData.view(bytes.buffer));
      print('ddddddddddd'+imagesNew.length.toString());
      print('ccccccc'+ _image.toString());*//*
      print('ccccccc'+ _image.toString());
    });
  }*/
  Future<dynamic> postImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print('aaaaaaaa' + imageUrl);
    listUrls.add(imageUrl);
    print("sizeeeeeeeeeeee" + listUrls.length.toString());
    if (listUrls.length == img.length) {
      updateRecord();
    }
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages() {
    for (var imageFile in img) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance
              .collection('images')
              .document(documnetID)
              .setData({'urls': imageUrls}).then((val) {
            print('succccccccccccccccccccccccccccccccccccccccccccc');
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void updateRecord() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm').format(now);


    var _firebaseRef = FirebaseDatabase().reference().child('chats');
    _firebaseRef.push().set({
      "name": _userController.text,
      "timestamp": formattedDate,
      "phone": _phoneController.text,
      "address": _locationMessage,
      "typeprocess": _dropdownValue,
      "statusProcess": _statusProcess,
      "images": listUrls,
      "personProcess": "",
    }).then((val) {
      print('aaaaaaaaa thanh cong');
      _showDialogSuccess();
//      Navigator.pop(context);
    });

  }

  void createRecord() {

      uploadImages();

  }

  void _showDialogSuccess() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: new Text(
              'Xác nhận!!!',
              style: TextStyle(color: Colors.red),
            ),
          ),
          content: new SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            child: Text("Phản ánh thành công"),
          )),
          actions: [
            new FlatButton(
              child: new Text('Đồng ý'),
              onPressed: () {
                setState(() {
                  FirebaseAuth.instance.currentUser().then((firebaseUser){
                    if(firebaseUser == null)
                    {
                      //signed out
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    }
                    else{
                      Navigator.pop(context);


                    }
                  }
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            'Xác nhận!!!',
            style: TextStyle(color: Colors.red),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Họ tên: ' + _userController.text),
                SizedBox(height: 10),
                new Text('Số điện thoại: ' + _phoneController.text),
                SizedBox(height: 10),
                new Text('địa chỉ: ' + _locationMessage),
                SizedBox(height: 10),
                new Text('Loại xử lý: ' + _dropdownValue),

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
    _selectImages = true;
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(img.length, (index) {
        File asset = img[index];
        return new Image.file(asset);
      }
      ),
    );
  }
//  new Image.file(_image)
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
      print('aaaaaa' + _locationMessage);

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
        title: Text("Phản ánh về đất đai môi trường"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, bottom: 10.0, top: 10.0),
              child: Container(
                height: 20.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    setState(() {
                      _userController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                      _phoneController.text.isEmpty
                          ? _validatePhone = true
                          : _validatePhone = false;



                    });
                    if(_locationMessage.contains("Đang lấy địa chỉ..")){
                      _validateLocation = true;
                      Toast.show("Vui lòng cung cấp quyền truy cập vị trí ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                    }else{
                      _validateLocation = false;
                    }
                    if(_image == null){
                      _validateImage = true;
                      Toast.show("Chụp ảnh xác thực phản ánh", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                    }else{
                      _validateImage = false;
                    }
                    if (!_validate && !_validatePhone && !_validateLocation && !_validateImage) {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      _showcontent();
                    }else{
                      Toast.show("Vui lòng cung cấp đầy đủ thông tin"+_image.path, context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                    }
                    //_showcontent();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Gửi phản ánh"),
                ),
              )),
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
                              'Thông tin người phản ánh',
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
                                errorText: _validatePhone
                                    ? 'SĐT không được rỗng'
                                    : null,
                              ),
                            ),
                          ),


                          SizedBox(height: 10),
                          Text(
                            "Chọn nội dung cần phản ánh",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
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
                              items: <String>[
                                'Lấn đất',
                                'Chiếm đất',
                                'Xả rác thải không đúng quy định',
                                'Ô nhiễm không khí',
                                'Ô nhiễm tiếng ồn',
                                'Khai thác cát trái phép'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              _locationMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 10),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  onPressed: () {
                                    //captureImage(ImageSource.camera)
//                                    loadAssets();
                                   // openCamera(context);
                                    if(counter > 2){
                                      Toast.show("không vượt quá 3 hình", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                    }else{
                                      getImage();
                                    }

                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: Text("Chụp ảnh"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),





                          Container(
                            height: 200,
                            child: Container(
                              child: new Center(
                                child: _image == null
                                    ? new Text('Chưa có ảnh được chọn')
                                    : GridView.count(
                                  crossAxisCount: 3,
                                  padding: EdgeInsets.only(bottom: 5),
                                  children: List.generate(img.length, (index) {
                                    File asset = img[index];
                                    return new Image.file(asset);
                                  }
                                  ),
                                ),
                              ),

                           /*   decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: _image == null
                                          ? AssetImage('assets/images/add.png')
                                          : Image.file(_image),
                                      fit: BoxFit.cover)),*/
                            )
//                             buildGridView()
//
                          ),
//                          buildGridView()
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
