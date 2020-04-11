import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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

List imageList(urls) {
  var list = <NetworkImage>[];
  print(urls[0]);
  for (int i=0; i < urls.length;  i++) {
    list.add(NetworkImage(urls[i]));
  }
  return list;
}

Widget buildList(List<Item> list) {

  return ListView.separated(
      itemBuilder: (context, index){
        final item = list[index];
        return
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    child: Carousel(
                      autoplay: false,
                      radius: Radius.circular(15.0),
                      borderRadius: true,
                      images: imageList(list[index].urls),
                      dotSize: 6.0,
                      indicatorBgPadding: 10.0,
                      overlayShadow: true,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8.0), child: Text(list[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),),
                  Padding(padding: EdgeInsets.all(8.0), child: Text(list[index].daily.toString()+" DKK", style: TextStyle(fontSize: 15.0),),)
                ],
              ),
            ),
          );
      },
      separatorBuilder: (con, index) => Container(),
      itemCount: list.length
  );
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
