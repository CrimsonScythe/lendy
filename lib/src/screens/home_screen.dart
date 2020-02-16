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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            }
        ),
      ),
    );

//    return MaterialApp(
//      home: Scaffold(
//        body: Text("Hello"),
//        floatingActionButton: FloatingActionButton.extended(
//            icon: Icon(Icons.add),
//            onPressed: null,
//            label: Text("Lend")),
//      ),
//    );
  }

}