 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'MyHomePage.dart';
import 'utils/flutkart.dart';
import 'utils/my_navigator.dart';
import 'widgets/walkthrough.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {

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
          print('roi');
          MyNavigator.goToHome(context);
//          Navigator.of(context).pushReplacementNamed('/login');
//          Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage()));

        }
      });
    });

  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  bool _validate = false;
  bool _validatePhone = false;
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
              child: Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 24.0),),),
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
                            child: Text(
                              'Quản lý',
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
                              controller: _passController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mật khẩu',
                                errorText:
                                _validatePhone ? 'Mật khẩu không được rỗng' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            margin: const EdgeInsets.only(left: 40,right: 40),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                              onPressed: () {
                                setState(() {
                                  _userController.text.isEmpty ? _validate = true : _validate = false;
                                  _passController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
                                });
                                if(!_validate && !_validatePhone){
                                  signIn(_userController.text, _passController.text).then((user) {
                                    if (user != null) {
                                      print('Logged in successfully.');

                                      /*   setState(() {

//                                        successMessage =
//                                        'Logged in successfully.\nYou can now navigate to Home Page.';
                                      });*/
                                    } else {
                                      print('Error while Login.');
                                    }
                                  });
                                }
                                //_showcontent();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text("Đăng nhập"),
                            ) ,
                          ),




                        ],
                      ),
                    ),
                  ],
                ),
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

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password))
          .user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }



  Future<bool> googleSignout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    return true;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}