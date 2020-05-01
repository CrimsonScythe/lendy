import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/ExploreBloc.dart';
import 'package:lendy/src/models/item.dart';
import 'package:lendy/src/screens/item_screen.dart';


Widget sExplore(context, ExploreBloc bloc) {
  return Container(
    //search
    //categories
    child: StreamBuilder(
        stream: bloc.itemStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          } else {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Item> itemList = bloc.cleanList(docs);
            return Column(
              children: <Widget>[
                Text('Search box'),
                Text('Category'),
                Container(
                  child: GridView.builder(
                      itemCount: itemList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (context, index){
                        return ItemCard(context, itemList[index]);
                      }
                  ),
                )
              ],
            );
          }
        }
    )

  );
}
//
Widget ItemCard(context, Item item) {
//  QuerySnapshot().documents[0].data[];
  return  Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ItemScreen(item: item)
            ));
            },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                  height: 140,
                  child: FittedBox(
                    child: CachedNetworkImage(
                        imageUrl: item.urls[0],
                      placeholder: (context, url) => CircularProgressIndicator(),
                    ),
//                    child: FadeInImage.memoryNetwork(
//                      image: doc.data['urls'][0],
//                      placeholder: kTransparentImage,
//                    ),
                    fit: BoxFit.fitWidth,
                  )
              ),
              Padding(padding: EdgeInsets.all(3.0), child: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),),
              Padding(padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0), child: Text(item.daily.toString()+" DKK daily", style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),),)
            ],
          ),
        )
    );
}