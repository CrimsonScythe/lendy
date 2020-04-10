import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/ListingsBloc.dart';

Widget sBorrow(context, ListingsBloc bloc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Looks like you don;'t have anttrig e"),
      SizedBox(height: 10),
      FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed('/lend'),
          label: Text("Explore items"))
    ],
  );
}