import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/validators.dart';
import 'package:lendy/src/models/item.dart';
import 'package:rxdart/rxdart.dart';

class ListingsBloc extends Object with Validators {

  final _repository = Repository();

  StreamController<bool> _fabStream = new StreamController();

  Stream<bool> get fabStream => _fabStream.stream;

  Function(bool) get changefabStream => _fabStream.sink.add;

  Stream<QuerySnapshot> get myListStream => myList();

  final _myList = BehaviorSubject<QuerySnapshot>();

//  Stream<QuerySnapshot> myList() {
//    return _repository.myList();
//  }

  Stream<QuerySnapshot> myList() {

    _repository.myList().then((value){
      if (value != null){
        _myList.sink.add(value);
      }
    });

    return _myList.stream;

  }


  List mapToList(List<DocumentSnapshot> docList) {
    List<Item> myList = [];
    if (docList != null){
      docList.forEach((document) {
        //TODO Make null checks??
        myList.add(new Item(document.data['cat'],
            document.data['title'],
            document.data['des'],
            int.parse(document.data['daily'].toString().replaceAll(("."), "")),
            int.parse(document.data['monthly'].toString().replaceAll(("."), "")),
            int.parse(document.data['weekly'].toString().replaceAll(".", "")),
            int.parse(document.data['depo'].toString().replaceAll(".", "")),
            document.data['urls'],
            document.documentID,
            document.data['imgNames'],
            document.data['name'],
            document.data['pUrl'],
            document.data['uID']
        ));
      });
    }

    //we use this stream for dispalying FAB in homescreen
    if (myList.isNotEmpty){
      _fabStream.sink.add(true);
    } else {
      _fabStream.sink.add(false);
    }

    return myList;
  }

  reset() {

  }

  dispose() async {
    // TODO: call close somewhere !
//    _navBarController.close();
  }
}
