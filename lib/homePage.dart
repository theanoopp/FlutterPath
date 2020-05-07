import 'dart:async';
import 'dart:convert';
import 'package:assignment/HomeItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'API.dart';
import 'loginPage.dart';
import 'models/Response.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser _myUser;
  FirebaseAuth _auth;
  var data = new List<Response>();
  bool loading = true;

  _getData() {
    API.getData().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        data = list.map((model) => Response.fromJson(model)).toList();
        data.removeWhere((test) => test.subPaths == null);
        loading = false;
      });
      _showLoggedInUser(context);

    });
  }

  void _logout() {
    _auth = FirebaseAuth.instance;
    _auth.signOut().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dog's Path",
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                _logoutDialog(context);
              })
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent))
          : Container(
              decoration: BoxDecoration(color: Color.fromRGBO(57, 57, 57, 1)),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return HomeItem(data: data[index]);
                },
              ),
            ),
    );
  }

  Future<void> _showLoggedInUser(BuildContext context) async {
    _auth = FirebaseAuth.instance;
    _myUser = await _auth.currentUser();

    if (_myUser != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Alert"),
                content: Text("Signed in as ${_myUser.displayName}"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  Future<void> _logoutDialog(BuildContext context) async {
    _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Logout ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
