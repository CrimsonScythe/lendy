import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;

  Future<DocumentReference> uploadPic(uID, pID) {

    var loc = "DK";

//    Map<String, Object> data = {
//      'location': loc,
//    };

    Map<String, Object> dat = Map();
    dat['location'] = loc;
    dat['pid'] = pID;

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

}