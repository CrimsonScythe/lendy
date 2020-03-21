import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';

class LendScreen extends StatefulWidget {
  final ItemBloc bloc = ItemBloc();

  @override
  State<StatefulWidget> createState() {
    return LendScreenState();
  }
}

class LendScreenState extends State<LendScreen> {
  var itemCount = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add item"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              imgW(widget.bloc),
              catW(widget.bloc),
              titleW(widget.bloc),
              desW(widget.bloc),
//            tagsW(widget.bloc),
              SizedBox(
                height: 10.0,
              ),
              uploadB(widget.bloc, context)
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder(
        stream: widget.bloc.nextValid,
        builder: (context, snapshot) {
          return FloatingActionButton.extended(
            backgroundColor: !snapshot.hasData || !snapshot.data ? Colors.grey : Colors.blue,
            onPressed: !snapshot.hasData || !snapshot.data ? null : () {
              print("pressed");
            },
              icon: Icon(Icons.navigate_next),
            label: Text('Next'),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }



  Widget imgW(bloc) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 200,
      child:
      Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: widget.bloc.picList,
              builder: (context, snapshot1) {
                return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (con, index) {
                      print(index);
                      if (!snapshot1.hasData || index == snapshot1.data.length) {
                        return dottedBorder();
                      }
//                if (snapshot1.data[index]==null) {
//                  return SizedBox.shrink();
//                }
                      else {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Image(
                              image: FileImage(snapshot1.data[index]),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: MaterialButton(
                                shape: CircleBorder(),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  print("index" + index.toString());
                                  _delete(context, index);
                                },
                              ),
                            )
                          ],
                        );
                      }
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: !snapshot1.hasData ? 1 : snapshot1.data.length + 1);
              },
            ),
          ),

          StreamBuilder(
              stream: widget.bloc.picList,
              builder: (context, snapshot) {
                return snapshot.data == null || snapshot.hasError ?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'You need to upload a picture',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.left,
                  ) ,
                ):
                SizedBox.shrink();
              }
          )
        ],
      ),
    );
  }

  Widget catW(ItemBloc bloc) {
    String defaultValue = '';
    List<String> cats = ['Choose Category', 'Photography',
      'Drones', 'Video Games and Consoles', 'Clothes and Bags', 'Sports',
      'Household Items', 'Laptops and Accessories', 'Phones and Tablets',
      'TVs and Monitors', 'Kids and Baby Items', 'Music and Accessories',
      'Travel Accessories', 'Books', 'Others'];
    return StreamBuilder(
        stream: bloc.drop,
        builder: (context, snapshot){
          return Align(
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
              onChanged: bloc.changeDrop,
              value: !snapshot.hasData ? cats[0]: snapshot.data,
              icon: Icon(Icons.arrow_drop_down),
//      onChanged: widget.bloc.photosList,
              items: cats.map((String cat){
                return new DropdownMenuItem<String>(
                  value: cat,
                  child: new Text(cat),
                );
              }).toList(),
            ),
          );
        }
    );
  }

  Widget titleW(ItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeTitle,
          decoration: InputDecoration(
              hintText: 'Enter title',
              labelText: 'Title',
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget desW(ItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.des,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeDes,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              hintText: 'Enter description',
              labelText: 'Description',
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget tagsW(ItemBloc bloc) {
    return Container();
  }

  Widget uploadB(ItemBloc bloc, context) {
    return Container();
  }

  Widget dottedBorder() {
    return DottedBorder(
        color: Colors.grey,
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        strokeWidth: 1,
        child: new InkWell(
          onTap: () {
            _showChoice(context);
          },
          child: new Container(
              height: 200,
              width: 200,
              child: Center(
                child: MaterialButton(
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    _showChoice(context);
                  },
                ),
              )),
        ));
  }

  void _showChoice(context) {
    showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Add photo"),
          children: <Widget>[
            new SimpleDialogOption(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Choose from device"),
              ),
              onPressed: () {
                widget.bloc.getImage();
                Navigator.pop(context);
              },
            ),
            new SimpleDialogOption(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Take photo"),
              ),
              onPressed: () {
                widget.bloc.takeImage();
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void _delete(context, index) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: Text('Confrim delete'),
          content: Text('Are you sure you want to delete the image?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                widget.bloc.deleteImage(index);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
