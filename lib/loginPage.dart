import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser myUser;
  bool loading = false;

  Future<FirebaseUser> _loginWithFacebook() async {
    var facebookLogin = FacebookLogin();
//    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken facebookAccessToken = result.accessToken;
      AuthCredential authCredential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);
      FirebaseUser user =
          (await _auth.signInWithCredential(authCredential)).user;
      return user;
    }
    return null;
  }

  void _login() {
    setState(() {
      loading = true;
    });
    _loginWithFacebook().then((response) {
      if (response != null) {
        myUser = response;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      }else{
        setState(() {
          loading = false;
        });
      }
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      debugPrint(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttonColor = Color.fromRGBO(59, 89, 152, 1);
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent))
          : Container(
              decoration: BoxDecoration(color: Color.fromRGBO(57, 57, 57, 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Sign in with your facebook account",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton.icon(
                          onPressed: _login,
                          icon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/fb_logo.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          label: Text(
                            "Sign in with Facebook",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          color: buttonColor,
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
