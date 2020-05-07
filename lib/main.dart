import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'homePage.dart';
import 'loginPage.dart';

void main() => runApp(MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(57, 57, 57, 1),
        accentColor: Color.fromRGBO(57, 57, 57, 1)
      ),
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      FirebaseUser myUser = await FirebaseAuth.instance.currentUser();
      if (myUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Color.fromRGBO(173, 173, 173, 1);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(57, 57, 57, 1)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/splash_image.gif"),
                width: 160,
                height: 160,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Dog's Path",
                style: TextStyle(
                    color: textColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "by",
                style: TextStyle(color: textColor),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "VirtouStack Softwares Pvt.Ltd",
                style: TextStyle(color: textColor, fontSize: 25),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
