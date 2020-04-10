import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/validators.dart';
import 'package:lendy/src/models/item.dart';

class ListingsBloc extends Object with Validators {

  final _repository = Repository();


  Stream<QuerySnapshot> myList() {
    return _repository.myList();
  }

  List mapToList(List<DocumentSnapshot> docList) {
    List<Item> myList = [];
    if (docList != null){
      docList.forEach((document) {
        //TODO Make null checks??
        myList.add(new Item(document.data['cat'],
            document.data['title'],
            document.data['des'],
            int.parse(document.data['daily']),
            int.parse(document.data['monthly']),
            int.parse(document.data['weekly']),
            int.parse(document.data['depo'])
        ));
      });
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
