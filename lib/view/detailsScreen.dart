import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

/*final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];*/

class detailsScreen extends StatefulWidget {
  @override
  _detailsScreenState createState() => _detailsScreenState();
}

class _detailsScreenState extends State<detailsScreen> {
  String name, timestamp, phone, note, address, typeprocess;
  bool statusProcess;
  dynamic images = new List<String>();
  int _current = 0;
  var listImg = new List<String>();
  final PageController controller = PageController();
  var msgStatusProcess;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller.page.round() != _current) {
        setState(() {
          _current = controller.page.round();
        });
      }
    });
  }
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
 void processUpdate(){
   //_database.reference().child("chats").child(todo.key).set(todo.toJson());
 }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
//    {'name': name, 'timestamp':timestamp,'phone': phone,'note': note,'address': address,'typeprocess': typeprocess,'statusProcess': statusProcess,'images': images});
    if (arguments != null) {
      this.name = arguments['name'];
      this.timestamp = arguments['timestamp'];
      this.phone = arguments['phone'];
      this.note = arguments['note'];
      this.address = arguments['address'];
      this.typeprocess = arguments['typeprocess'];
      this.statusProcess = arguments['statusProcess'];
      this.images = arguments['images'];
    }


    for (var name in images) {
      listImg.add(name);
    }
    print('in'+ listImg.length.toString());
    if (statusProcess){
      msgStatusProcess ="Đã xử lý";

    }else{
      msgStatusProcess ="Chưa xử lý";
    }

    // print(arguments['images']);
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Card(
          margin: EdgeInsets.all(12),
          elevation: 2,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    child: Stack(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
//                   enlargeCenterPage: true,
//                   aspectRatio: 2.0,

                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                      items: listImg
                          .map((item) => Container(
                                  child: GestureDetector(
                                child: Image.network(item,
                                    fit: BoxFit.cover, width: 1000),
                                onTap: () {
                                  print('lick ' + item);
                                  MyNavigator.goToFullScreen(context,item);
                                },
                              )))
                          .toList(),
                    ),

                  ],
                )),
                SizedBox(height: 20),
                Text("Tình trạng: " + typeprocess,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 10),
                Text(
                  "Vị trí: " + address,
                  style: TextStyle(color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 10),
                Text("Ngày báo cáo: " + timestamp,
                    style: TextStyle(color: Colors.black54)),
                SizedBox(height: 10),
                Text("Người báo cáo: " + name,
                    style: TextStyle(color: Colors.black54)),
                SizedBox(height: 10),
                Text("Ghi chú: " + note,
                    style: TextStyle(color: Colors.black54)),
                SizedBox(height: 10),
                // ignore: unrelated_type_equality_checks
                Text("Trạng thái: " + msgStatusProcess,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                      processUpdate();
                      //_showcontent();
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Xử lý "),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(150.0),
              child: Text("Well hello there!"),
            ),
          ),
        ),
      ),
    );
  }
}
