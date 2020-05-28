import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<login> {
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
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () {
                                setState(() {
                                  _userController.text.isEmpty ? _validate = true : _validate = false;
                                  _passController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
                                });
                                if(!_validate && !_validatePhone){
                                  signIn(_userController.text, _passController.text).then((user) {
                                    if (user != null) {
                                      print('Logged in successfully.');
                                      setState(() {
                                        successMessage =
                                        'Logged in successfully.\nYou can now navigate to Home Page.';
                                      });
                                    } else {
                                      print('Error while Login.');
                                    }
                                  });
                                }
                                //_showcontent();
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Đăng nhập"),
                            ) ,
                          )

                          /*   Container(
                            height: 200,
                            margin: const EdgeInsets.only(left: 40,right: 40),
                            child:  Expanded(
                              child: buildGridView(),
                            ),
                          ),
                          SizedBox(height: 20),*/
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
    /*  body: Center(
          child: Column(
        children: [
         *//* Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 100),
                  child: Text(
                    'Quản lý',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    validator: validateEmail,
                    onSaved: (value) {
                      _emailId = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.green,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      labelText: "Email Id",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    validator: validatePassword,
                    onSaved: (value) {
                      _password = value;
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.green,
                              width: 2,
                              style: BorderStyle.solid)),
                      labelText: "Password",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          (errorMessage != ''
              ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
              : Container()),
          // ignore: deprecated_member_use
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      signIn(_emailId, _password).then((user) {
                        if (user != null) {
                          print('Logged in successfully.');
                          setState(() {
                            successMessage =
                                'Logged in successfully.\nYou can now navigate to Home Page.';
                          });
                        } else {
                          print('Error while Login.');
                        }
                      });
                    }
                  },
                ),
                FlatButton(
                  child: Text(
                    'Get Register',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    *//**//*Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => RegistrationPage(),
                                  ),
                                );*//**//*
                  },
                ),
              ],
            ),
          ),*//*
        ],
      )),*/
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

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)) as FirebaseUser;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      handleError(e);
    }
    return currentUser;
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
