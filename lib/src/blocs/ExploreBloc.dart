import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/models/item.dart';
import 'package:rxdart/rxdart.dart';

class ExploreBloc extends Object {

  final _repository = Repository();

  final _items = BehaviorSubject<QuerySnapshot>();

  Future<QuerySnapshot> get itemFuture =>
      _repository.items();

  Stream<QuerySnapshot> get itemStream =>
      buildItemStream();

  Stream<QuerySnapshot> buildItemStream() {

    _repository.items().then((value){
      if (value != null){
        _items.sink.add(value);
      }
    });

    return _items.stream;

  }

  List cleanList(List<DocumentSnapshot> docList) {
    List<Item> myList = [];

    if (docList != null) {
//      print("userID" + _repository.user_ID);

      docList.forEach((document){
//        print("doc ID" + document.documentID);
        if (document.data['uID'] != _repository.user_ID){
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
        }
      });
    }

    return myList;

  }


}