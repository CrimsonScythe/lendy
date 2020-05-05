import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/ChatBloc.dart';
import 'package:transparent_image/transparent_image.dart';

Widget sChat(context, ChatBloc bloc) {
  return StreamBuilder(
    stream: bloc.chatsStream,
    builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      if (snapshot.hasData){
        return chatList(snapshot, bloc);
      } else {
        return Center(child: Text("No chats"),);
      }
    },
  );
}

Widget chatList(snapshot, bloc) {

  return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                image: snapshot.data.documents[index].data["prodUrl"],
                width: 50.0, height: 50.0,),
            ),
          ),
          title: Text(snapshot.data.documents[index].data["prodName"]),
          subtitle: Text(bloc.extractName(snapshot,index)),
          onTap: () {},
        );
      }
  );

}
