import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

//  Future<DocumentReference> uploadPic(uID, pID) {
//
//    var loc = "DK";
//
////    Map<String, Object> data = {
////      'location': loc,
////    };
//
//    Map<String, Object> dat = Map();
//    dat['location'] = loc;
//    dat['pid'] = pID;
//
//    return _firestore.collection("users").document(uID).collection("lend")
//        .add(dat);
//  }

   List<Future> uploadImage(uID, photos) {
//    var list = List<Future<StorageTaskSnapshot>>();
    var fut = <Future>[];
    for (var i = 0; i < photos.length; i++){
      fut.add(_firebaseStorage.ref().child('images/' + i.toString() + uID + new DateTime.now().millisecondsSinceEpoch.toString()).putFile(photos[i]).onComplete);

//      _firebaseStorage.ref().child('images/' + i.toString() + uID + new DateTime.now().millisecondsSinceEpoch.toString()).putFile(photos[0]).onComplete;
    }

    return fut;
  }

  Future<DocumentReference> uploadItem(uID,
      cat, title, des, daily, weekly, monthly, depo) {

    var loc = "DK";

//    Map<String, Object> data = {
//      'location': loc,
//    };

    Map<String, Object> dat = Map();
    dat['cat'] = cat;
    dat['title'] = title;
    dat['des'] = des;
    dat['daily'] = daily;
    dat['weekly'] = weekly;
    dat['monthly'] = monthly;
    dat['depo'] = depo;
    dat['loc'] = loc;
    dat['time'] = DateTime.now();

    return _firestore.collection("users").document(uID).collection("lend")
        .add(dat);
  }
  
  Future<void> addUser(uID) {

    Map<String, Object> dat = Map();
    dat['ctime'] = Timestamp.now();

    return _firestore.collection("users").document(uID)
        .setData(dat);
//        .setData(new Map<String, Object>{"ctime": Timestamp.now()})
  }



  Stream<QuerySnapshot> myList(uID) {
     return _firestore.collection('users').document(uID).collection('lend').getDocuments().asStream();
  }

}