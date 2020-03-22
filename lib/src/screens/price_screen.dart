import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return PriceScreenState();
  }

}

class PriceScreenState extends State<PriceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set pricing'),
      ),
      body: Container(),
      floatingActionButton: StreamBuilder(
        stream: ,
        builder: (context, snapshot) {

        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

  }


}