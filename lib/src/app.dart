import 'package:flutter/material.dart';

class App extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }

}

class AppState extends State<App> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text("Hello"),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            onPressed: null,
            label: Text("Lend")),
      ),
    );
  }


}