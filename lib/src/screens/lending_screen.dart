import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/ListingsBloc.dart';
import 'package:lendy/src/models/item.dart';

Widget sLend(context, ListingsBloc bloc) {
  return Container(
    child: StreamBuilder(
        stream: bloc.myList(),
        builder: (scontext, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Item> itemList = bloc.mapToList(docs);
            if (itemList.isNotEmpty){
              return buildList(itemList);
            } else {
              return wEmpty(context);
            }
          } else {
            return wEmpty(context);
          }
        }),
  );
}

Widget buildList(List<Item> list) {
  return ListView.separated(
      itemBuilder: (context, index){
        final item = list[index];
        return Text(item.title);
      },
      separatorBuilder: (con, index) => Divider(),
      itemCount: list.length);
}



Widget wEmpty(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Looks like you don;'t have anttrig e"),
      SizedBox(height: 10),
      FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed('/lend'),
          icon: Icon(Icons.add),
          label: Text("Add item"))
    ],
  );
}
