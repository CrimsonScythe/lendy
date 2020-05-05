import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/ChatBloc.dart';
import 'package:lendy/src/models/item.dart';
import 'package:lendy/src/screens/chat.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemScreen extends StatefulWidget {

  final Item item;


  @override
  State<StatefulWidget> createState() {
    return ItemScreenState();
  }

  ItemScreen({Key key, @required this.item});


}

class ItemScreenState extends State<ItemScreen> {

  ChatBloc chatBloc;


  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc();
  }

  StreamSubscription<bool> subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Carousel(
                borderRadius: true,
                radius: Radius.circular(0.0),
                autoplay: false,
                images: imageList(widget.item.urls),
                dotSize: 6.0,
                dotBgColor: Colors.grey.withOpacity(0.6),
                indicatorBgPadding: 8.0,
                overlayShadowSize: 0.0,
                overlayShadow: true,
              ),
//              child: FadeInImage.memoryNetwork(
//                  placeholder: kTransparentImage,
//                  image: widget.item.urls[0]),
            ),
            ownedBy(widget.item),
            title(widget.item.title),
            desc(widget.item.des),
            cat(widget.item.category),
            pricing(widget.item.prices),
            SizedBox(height: 10,),
            StreamBuilder(
                stream: chatBloc.showProgress,
                builder: (context, snapshot){
                  if (snapshot.hasData && snapshot.data){
                    return CircularProgressIndicator();
                  } else {
                    return RaisedButton(
                      child: Text('Chat'),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      onPressed: () {
                        chat(context, widget.item.uID, widget.item.userName, widget.item.userProfileUrl, widget.item.docID, widget.item.title, widget.item.urls[0]);
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    if(subscription!=null) subscription.cancel();


  }

  void chat(context, u2ID, u2Name, p2url, prodID, prodName, prodUrl) {


    subscription = chatBloc.showProgress.listen((data){});

    var chatID = chatBloc.createChat(u2ID, u2Name, prodID, prodName, prodUrl);
    chatBloc.createChatUsers(u2ID, u2Name, p2url);


    subscription.onData((data){
      if (!data){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(bloc: chatBloc, chatID: chatID)
        ));
      }
    });

  }




}

Widget ownedBy(Item item) {
  return
    Padding(padding: EdgeInsets.all(10.0),
    child: Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25.0,
          child: ClipOval(
            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: item.userProfileUrl,
              width: 50.0, height: 50.0,),
          ),
        ),
        SizedBox(width: 10.0,),
        Column(children: <Widget>[
          Text('Owned by'),
          Text(item.userName)
        ],)
      ],
    ),
    );

}


Widget title(val) {
  return Column(
    children: <Widget>[
      Text('Title', style: TextStyle(fontWeight: FontWeight.bold),),
      Text(val)
    ],
  );
}

Widget desc(val) {
  return Column(
    children: <Widget>[
      Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
      Text(val)
    ],
  );
}

Widget cat(val) {
  return Column(
    children: <Widget>[
      Text('Category', style: TextStyle(fontWeight: FontWeight.bold),),
      Text(val)
    ],
  );
}

List imageList(urls) {
  var list = <FadeInImage>[];
  print(urls[0]);

  for (int i=0; i < urls.length;  i++) {
    list.add(FadeInImage.memoryNetwork(image: urls[i], placeholder: kTransparentImage,));
  }
  return list;
}

Widget pricing(list) {
  return Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Text('Daily'),
          Text(list[0].toString() + ' DKK')
        ],
      ),
      Column(
        children: <Widget>[
          Text('Weekly'),
          Text(list[1].toString() + ' DKK')
        ],
      ),
      Column(
        children: <Widget>[
          Text('Monthly'),
          Text(list[2].toString() + ' DKK')
        ],
      ),
    ],
  );
}