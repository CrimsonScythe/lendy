import 'dart:async';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/resources/bloc_provider.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import 'package:lendy/src/models/item.dart';
import 'package:lendy/src/screens/lend.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;


class EditScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return EditScreenState();
  }



  final List urls;
  final Item item;
  final int index;

  EditScreen({Key key, @required this.urls, @required this.item,@required this.index});

}

class EditScreenState extends State<EditScreen> {

  ItemBloc bloc;


  StreamSubscription<bool> subscription;

  @override
  Widget build(BuildContext context) {
    bloc  = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit item'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Hero(
                  tag: 'hero'+widget.index.toString(),
                  child: Carousel(
                    borderRadius: true,
                    radius: Radius.circular(0.0),
                    autoplay: false,
                    images: imageList(widget.urls),
                    dotSize: 6.0,
                    dotBgColor: Colors.grey.withOpacity(0.6),
                    indicatorBgPadding: 8.0,
                    overlayShadowSize: 0.0,
                    overlayShadow: true,
                  ),
              ),
            ),
            title(widget.item.title),
            desc(widget.item.des),
            cat(widget.item.category),
            pricing(widget.item.prices),
            SizedBox(height: 10,),
            StreamBuilder(
              stream: bloc.showProgress,
                builder: (context, snapshot){
                  if (snapshot.hasData && snapshot.data) {
                    return CircularProgressIndicator();
                  } else {
                    return Row
                      (mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(child: Text('Edit'),
                          padding: EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          onPressed: () {

                            edit(widget.item);
                          },),
                        SizedBox(width: 10.0,),
                        RaisedButton(child: Text('Delete'),
                          padding: EdgeInsets.all(12.0),
                          color: Colors.red,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          onPressed: () {
                            delete(widget.item);
                          },)
                      ],
                    );
                  }
                }
                )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

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


  void edit (Item item) async {

    ItemBloc bloc = BlocProvider.of(context);

//    var list = List<File>();
//
//    for (int i=0; i < item.urls.length; i++){
//      var direc = await getApplicationDocumentsDirectory();
//      var res = await http.get(item.urls[i]);
//      var path = direc.path;
//      var time = DateTime.now();
//      var file = File('$path/$time'+i.toString()+'.png');
//      var fileReal = await file.writeAsBytes(res.bodyBytes);
//
//      list.add(fileReal);
//    }

    bloc.fetchItems(item);
//    bloc.setImage(list);

    bloc.drop = item.category;
    bloc.title = item.title;
    bloc.des = item.des;

    bloc.daily = item.daily.toString();
    bloc.weekly = item.weekly.toString();
    bloc.monthly = item.monthly.toString();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          LendScreen(titleText: 'Edit item',item: item,),
    ));

  }

  void delete(Item item) {
    ItemBloc bloc = BlocProvider.of(context);

    subscription = bloc.uploadComplete.listen((data){});

    bloc.deleteItem(item.docID, item.imgNames);

    subscription.onData((data){
      if (data){
        bloc.resetAll();
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    });

  }

  @override
  void dispose() {
    super.dispose();

    if(subscription!=null) subscription.cancel();
    bloc.reset();

  }

}

List imageList(urls) {
  var list = <FadeInImage>[];
  print(urls[0]);

  for (int i=0; i < urls.length;  i++) {
    list.add(FadeInImage.memoryNetwork(image: urls[i], placeholder: kTransparentImage,));
  }
  return list;
}