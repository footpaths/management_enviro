import 'package:environmental_management/model/reportModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:flutter/src/gestures/tap.dart';

class home extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<home> {
  final _text = TextEditingController();
  bool _validate = false;
  List<reportModel> _list = List();
  reportModel _model;
  DatabaseReference itemRefShop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final dbRef = FirebaseDatabase.instance.reference().child("chats");
    dbRef.once().then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;
      _list.clear();
      for( var individualKey in KEYS){
        reportModel model =  new reportModel(DATA[individualKey]['name'], DATA[individualKey]['timestamp'], DATA[individualKey]['phone']
            , DATA[individualKey]['note'],DATA[individualKey]['address'] ,DATA[individualKey]['typeprocess'] , DATA[individualKey]['statusProcess'],DATA[individualKey]['images']
        );

        _list.add(model);
      }
      if(mounted) {
        setState(() {
          print('leng: '+ _list.length.toString());
        });
      }

    });
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('TextField Demo'),
        ),
        body:SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //Header Container
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text("Header"),
              ),

              //Body Container
              Expanded(
                  child: Container(
          child: _list.length == 0 ? new Text("no data"): new ListView.builder(
            itemCount: _list.length,
            itemBuilder: (_, index){
              return PostsUI(_list[index].name, _list[index].timestamp , _list[index].phone , _list[index].note , _list[index].address ,_list[index].typeprocess ,_list[index].statusProcess , _list[index].images );
            },
          ),
        )

              ),

              //Footer Container
              //Here you will get unexpected behaviour when keyboard pops-up.
              //So its better to use `bottomNavigationBar` to avoid this.

            ],
          ),
        ),


    );
  }
  Widget PostsUI(String  name,String timestamp,String phone,String note,String address,String typeprocess,bool statusProcess, dynamic images ){
    return  Container(
      alignment: Alignment.topLeft,
        child: Column(

          children: <Widget>[
            Text("Ngày cập nhật : "+"timestamp",),
            SizedBox(
              height: 10.0,
            ),
            Text("Người cập nhật: "+name)
          ],
        )

    );
  }
}
