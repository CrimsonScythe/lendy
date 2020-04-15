import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/models/item.dart';
import 'package:transparent_image/transparent_image.dart';

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


  @override
  Widget build(BuildContext context) {
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
            Row
              (mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              RaisedButton(child: Text('Edit'),
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                onPressed: () {
                edit();
                },),
              SizedBox(width: 10.0,),
              RaisedButton(child: Text('Delete'),
                  padding: EdgeInsets.all(12.0),
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                onPressed: () {
                delete();
                },)
            ],)
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

  void edit() {

  }

  void delete() {

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