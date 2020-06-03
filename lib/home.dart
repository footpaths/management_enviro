import 'package:environmental_management/model/reportModel.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      for (var individualKey in KEYS) {
        reportModel model = new reportModel(
            DATA[individualKey]['name'],
            DATA[individualKey]['timestamp'],
            DATA[individualKey]['phone'],
            DATA[individualKey]['note'],
            DATA[individualKey]['address'],
            DATA[individualKey]['typeprocess'],
            DATA[individualKey]['statusProcess'],
            DATA[individualKey]['images']);

        _list.add(model);
      }
      if (mounted) {
        setState(() {
          print('leng: ' + _list.length.toString());
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
      body: SafeArea(
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
              child: _list.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : new ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          child: PostsUI(
                              _list[index].name,
                              _list[index].timestamp,
                              _list[index].phone,
                              _list[index].note,
                              _list[index].address,
                              _list[index].typeprocess,
                              _list[index].statusProcess,
                              _list[index].images),
                          onTap: () {
                            MyNavigator.goToDetails(context,
                                _list[index].name,
                                _list[index].timestamp,
                                _list[index].phone,
                                _list[index].note,
                                _list[index].address,
                                _list[index].typeprocess,
                                _list[index].statusProcess,
                                _list[index].images,

                            );
                          }
                        );

                      },
                    ),
            )),
          ],
        ),
      ),
    );
  }

  Widget PostsUI(String name, String timestamp, String phone, String note,
      String address, String typeprocess, bool statusProcess, dynamic images) {
    return Card(

      margin: EdgeInsets.all(12),
      elevation: 4,
      color: Colors.red[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Text("Tình trạng: "+ typeprocess, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
            SizedBox(height: 4),

            Text("Vị trí: "+ address, style: TextStyle(color: Colors.black54), maxLines: 2, overflow: TextOverflow.fade,),
            Text("Ngày báo cáo: "+ timestamp, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
    /*Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Text(
              "Ngày cập nhật : " + "timestamp",
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Người cập nhật: " + name)
          ],
        )
    );*/
  }
}
