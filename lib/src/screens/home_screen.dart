import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(title: Text("Home"), ),
      body: Center(
        child: RaisedButton(
          child: Text("logout"),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            }
        ),
      ),
    );

  }

}