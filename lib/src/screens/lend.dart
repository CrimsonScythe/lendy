import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import 'package:lendy/src/blocs/bloc.dart';
import 'package:transparent_image/transparent_image.dart';

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
    widget.bloc.pic.listen((data){
      setState(() {
        itemCount=itemCount+1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add item"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            imgW(widget.bloc),
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
      floatingActionButton:
//          StreamBuilder(
//            stream: widget.bloc.nextValid,
//          )
          FloatingActionButton.extended(
        backgroundColor: Colors.grey,
        onPressed: () {},
        icon: Icon(Icons.navigate_next),
        label: Text('Next'),
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
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index){
          return StreamBuilder(
            stream: widget.bloc.pic,
            builder: (context, snapshot1) {
              if (!snapshot1.hasData || widget.bloc.photosList.length <= index) {
                return dottedBorder();
              } else {

                return Image(
                    image: FileImage(widget.bloc.photosList[index])
                );
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return const SizedBox(width: 10.0,);
        },
//        children: <Widget>[
//          StreamBuilder(
//            stream: widget.bloc.pic,
//            builder: (context, snapshot1) {
//              if (!snapshot1.hasData) {
//                return dottedBorder();
//              } else {
//                return Image(image: FileImage(snapshot1.data));
//              }
//            },
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//
//          SizedBox(
//            width: 10.0,
//          ),
//
//        ],
      ),

    );

//   ImagePicker.pickImage(source: ImageSource.camera);
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
        child: InkWell(
          onTap: () {
            _showChoice(context);
          },
          child: Container(
              height: 200,
              width: 200,
              child: Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                      color: Colors.blue, shape: CircleBorder()),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      _showChoice(context);
                    },
                  ),
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
              child: Text(
                "Choose from device",
              ),
              onPressed: () {
                widget.bloc.getImage();
                Navigator.pop(context);
                },
            ),
            new SimpleDialogOption(
              child: Text("Take photo"),
              onPressed: () {
                widget.bloc.takeImage();
              },
            )
          ],
        ));
  }
}
