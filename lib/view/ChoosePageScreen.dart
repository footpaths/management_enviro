 import 'package:environmental_management/Constants/icon_image.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';



class ChoosePageScreen extends StatefulWidget {
  @override
  ChoosePageScreenState createState() {
    return ChoosePageScreenState();
  }
}

class ChoosePageScreenState extends State<ChoosePageScreen> {

  @override
  Future<void> initState()   {
    super.initState();
    setState(() {
      FirebaseAuth.instance.currentUser().then((firebaseUser){
        if(firebaseUser == null)
        {
          //signed out

        }
        else{
          //signed in
          print('roi'+firebaseUser.email);
          MyNavigator.goToHome(context);
//          Navigator.of(context).pushReplacementNamed('/login');
//          Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage()));

        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 100.0,
              decoration: new BoxDecoration(
                color: Colors.green,
                boxShadow: [
                  new BoxShadow(blurRadius: 2.0)
                ],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Center(child: Text("Tài Nguyên Môi Trường", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 24.0),),),
            ),
            //Header Container

            //Body Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.red,
                              backgroundImage: AssetImage(PageImage.IC_ADD),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(

                            margin: const EdgeInsets.only(left: 40,right: 40),
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                              onPressed: () {
                                MyNavigator.goToReport(context);
                                //_showcontent();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text("Báo cáo sai phạm môi trường"),
                            ) ,
                          ),
                          SizedBox(height: 30),
                          Container(

                            margin: const EdgeInsets.only(left: 40,right: 40),
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.brown)),
                              onPressed: () {
                                MyNavigator.goToPDF(context);
                                //_showcontent();
                              },
                              color: Colors.brown,
                              textColor: Colors.white,
                              child: Text("Xem thông tin bản đồ quy hoạch"),
                            ) ,
                          ),
                          SizedBox(height: 10),







                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),

              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text("Hotline : 0909894347"),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                    MyNavigator.goToLogin(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Đăng nhập"),
                  )
                ],
              ),
            ),
            //Footer Container
            //Here you will get unexpected behaviour when keyboard pops-up.
            //So its better to use `bottomNavigationBar` to avoid this.
          ],
        ),
      ),

    );
  }
}