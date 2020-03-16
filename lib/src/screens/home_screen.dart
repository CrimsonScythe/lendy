import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../blocs/PostsBloc.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

//  HomeScreen({Key key, @required this.uID}) : super(key: key);

}


class HomeScreenState extends State<HomeScreen> {

  PostsBloc _postsBloc = new PostsBloc();



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: Text("Home"), ),
      body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text("logout"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  }
              ),
              RaisedButton(
                  child: Text("submit"),
                  onPressed: () async {
                    _postsBloc.upload("picID");
                  }
              ),
              StreamBuilder(
                stream: _postsBloc.showProgress,
                builder: (context, snapshot){
                  if (!snapshot.hasData){
                    return Container();
                  }
                  if (snapshot.hasData && snapshot.data){
                    return CircularProgressIndicator();
                  } else {
                    if (!snapshot.data){
                      return Container();
                    }
                  }
                  return Container();
                },
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/lend');
        }, label: Text('Lend'), icon: Icon(Icons.add),),
    );

//    return new Scaffold(
//      appBar: new AppBar(title: Text("Home"), ),
//      body: Center(
//        child: Column(
//          children: <Widget>[
//            RaisedButton(
//                child: Text("logout"),
//                onPressed: () async {
//                  await FirebaseAuth.instance.signOut();
//                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
//                }
//            ),
//            RaisedButton(
//                child: Text("submit"),
//                onPressed: () async {
//                  _postsBloc.upload("picID");
//                }
//            ),
//            StreamBuilder(
//              stream: _postsBloc.showProgress,
//              builder: (context, snapshot){
//                if (!snapshot.hasData){
//                  return Container();
//                }
//                if (snapshot.hasData && snapshot.data){
//                  return CircularProgressIndicator();
//                } else {
//                  if (!snapshot.data){
//                    return Container();
//                  }
//                }
//                return Container();
//              },
//            )
//          ],
//        )
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: null, label: Text('Lend'), icon: Icon(Icons.add),),
//    );

  }

}