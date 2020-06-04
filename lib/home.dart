import 'dart:math';

import 'package:environmental_management/model/reportModel.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:tabbar/tabbar.dart';

class home extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<home>
    with AutomaticKeepAliveClientMixin<home> {
  final _text = TextEditingController();
  bool _validate = false;
  final List<reportModel> _list = List();
  final List<reportModel> _listActive = List();
  reportModel _model;
  DatabaseReference itemRefShop;
  bool _isVisible = true;
  final controller = PageController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String personPro;
    var dbRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        FirebaseAuth.instance.currentUser().then((firebaseUser) {
          if (firebaseUser == null) {
            //signed out

          } else {
            //signed in
            personPro = firebaseUser.email;
            print('aaaa' + personPro);
//          Navigator.of(context).pushReplacementNamed('/login');
//          Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage()));

          }
        });
      });
    }

//   loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new MyHomePageState();
    });

    return null;
  }

  void loadData() {
      dbRef = FirebaseDatabase.instance.reference().child("chats");
    dbRef.once().then((DataSnapshot dataSnapshot) {
      var KEYS = dataSnapshot.value.keys;
      var DATA = dataSnapshot.value;
      _list.clear();
      _listActive.clear();
      for (var individualKey in KEYS) {
        reportModel model = new reportModel(
          DATA[individualKey]['name'],
          DATA[individualKey]['timestamp'],
          DATA[individualKey]['phone'],
          DATA[individualKey]['note'],
          DATA[individualKey]['address'],
          DATA[individualKey]['typeprocess'],
          DATA[individualKey]['statusProcess'],
          individualKey,
          DATA[individualKey]['images'],
          DATA[individualKey]['personProcess'],
        );
        if (model.statusProcess) {
          _list.add(model);
        } else {
          _listActive.add(model);
        }
      }
      if (mounted) {
        setState(() {
          print('leng: ' + _list.length.toString());
        });
      }
    });
  }
  Future<void> _showMyDialog(String individualKey) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bạn muốn xóa? '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vui lòng kiểm tra trước khi xóa'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xóa'),
              onPressed: () {
                dbRef.child(individualKey).remove();

                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Bỏ qua'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    textStyle() {
      return new TextStyle(color: Colors.white, fontSize: 30.0);
    }

    print("tab1: Builder");

    loadData();
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Smiple Tab Demo"),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Đã xử lý",
              ),
              new Tab(
                text: "Chưa xử lý",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Container(
              child: _list.length == 0
                  ? Center(child: Text("Chưa có dữ liệu.."))
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
                              _list[index].images,
                               true
                          ),
                          onTap: () {
                            MyNavigator.goToDetails(
                              context,
                              _list[index].name,
                              _list[index].timestamp,
                              _list[index].phone,
                              _list[index].note,
                              _list[index].address,
                              _list[index].typeprocess,
                              _list[index].statusProcess,
                              _list[index].individualKey,
                              _list[index].images,
                              _list[index].personProcess,
                            );
                          },
                          onLongPress: () {
                            if(personPro.contains("nguyen.footpaths@gmail.com")){
                              _showMyDialog(_list[index].individualKey);
                            }

                          },
                        );
                      },
                    ),
            ),
            new Container(
              child: _listActive.length == 0
                  ? Center(child: Text("Chưa có dữ liệu.."))
                  : new ListView.builder(
                      itemCount: _listActive.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          child: PostsUI(
                              _listActive[index].name,
                              _listActive[index].timestamp,
                              _listActive[index].phone,
                              _listActive[index].note,
                              _listActive[index].address,
                              _listActive[index].typeprocess,
                              _listActive[index].statusProcess,
                              _listActive[index].images,
                             false
                          ),
                          onTap: () {
                            MyNavigator.goToDetails(
                              context,
                              _listActive[index].name,
                              _listActive[index].timestamp,
                              _listActive[index].phone,
                              _listActive[index].note,
                              _listActive[index].address,
                              _listActive[index].typeprocess,
                              _listActive[index].statusProcess,
                              _listActive[index].individualKey,
                              _listActive[index].images,
                              _listActive[index].personProcess,
                            );
                          },
                          onLongPress: () {
                            print('aaaaaaaaa: khong phai  bạn');
                            /*  if(personPro.contains("nguyen.footpaths@gmail.com")){
                                print('aaaaaaaaa: chính bạn' );
                              }else{
                                print('aaaaaaaaa: khong phai  bạn' );
                              }*/
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PostsUI(String name, String timestamp, String phone, String note,
      String address, String typeprocess, bool statusProcess, dynamic images, bool color) {
   var colorType = Colors.red[200];
   if(color){
     colorType = Colors.green[200];
   }
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      color: colorType,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Tình trạng: " + typeprocess,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 4),
            Text(
              "Vị trí: " + address,
              style: TextStyle(color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            Text("Ngày báo cáo: " + timestamp,
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
