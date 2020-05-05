import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  signOut() {

  }

   List<Future> uploadImage(uID, photos, imgNames) {
//    var list = List<Future<StorageTaskSnapshot>>();
    var fut = <Future>[];
    for (var i = 0; i < photos.length; i++){

      fut.add(_firebaseStorage.ref().child
        ('images/' + imgNames[i]).putFile(photos[i]).onComplete);

//      _firebaseStorage.ref().child('images/' + i.toString() + uID + new DateTime.now().millisecondsSinceEpoch.toString()).putFile(photos[0]).onComplete;
    }

    return fut;
  }


  List<Future> deleteImage(imgNames) {

    var fut = <Future>[];
    for (var i = 0; i < imgNames.length; i++){
      fut.add(_firebaseStorage.ref().child
        ('images/' + imgNames[i]).delete());

    }
    return fut;
  }

  Future deleteItem(uID, dID, imgNames) {

     return _firestore.collection("users")
         .document(uID).collection("lend")
         .document(dID).delete();

  }

  List<Future> updateImage(uID, imgNames, photos)  {

    var fut = <Future>[];
    for (var i = 0; i < photos.length; i++){

      fut.add(_firebaseStorage.ref().child
        ('images/' + imgNames[i]).putFile(photos[i]).onComplete);

    }

    return fut;


  }

  List<Future> downloadURLs(list) {
     var fut = <Future>[];

     list.forEach((f){

       print(f.ref.getDownloadURL().toString());

       fut.add(f.ref.getDownloadURL());
     });
     return fut;
  }

  Future<void> updateItem(uID, dID, 
      cat, title, des, daily, weekly, monthly, depo, urls) {

    Map<String, Object> data = Map();
    data['cat'] = cat;
    data['title'] = title;
    data['des'] = des;
    data['daily'] = daily;
    data['weekly'] = weekly;
    data['monthly'] = monthly;
    data['depo'] = depo;
    data['loc'] = 'DK';
    data['urls'] = urls;
    data['time'] = DateTime.now();
     
     return _firestore.collection("users")
         .document(uID).collection("lend")
         .document(dID).updateData(data);
  }
  
  Future<DocumentReference> uploadItem(uID,
      cat, title, des, daily, weekly, monthly, depo, urls, imgNames, Position loc,
      String userName, String profileUrl) {


    Map<String, Object> dat = Map();
    dat['cat'] = cat;
    dat['title'] = title;
    dat['des'] = des;
    dat['daily'] = daily;
    dat['weekly'] = weekly;
    dat['monthly'] = monthly;
    dat['depo'] = depo;
    dat['loc'] = [loc.latitude, loc.longitude];
    dat['urls'] = urls;
    dat['imgNames'] = imgNames;
    dat['time'] = DateTime.now();
    dat['name'] = userName;
    dat['pUrl'] = profileUrl;
    dat['uID'] = uID;


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



  Future<QuerySnapshot> myList(uID) {
     return _firestore.collection('users').document(uID).collection('lend').orderBy('time', descending: true).getDocuments();
  }

  Future<QuerySnapshot> getItems(uID) {
    return _firestore.collectionGroup('lend').getDocuments();

  //:TODO need to filter UID locally as firebase does not dupport !=
//    return _firestore.collectionGroup('lend').orderBy('time', descending: true).getDocuments();

  }

  Future<void> createChat(uID, uName, u2ID, u2Name, prodID, prodUrl, prodName) {

    Map<String, Object> data = Map();
//    data['user1'] = uName;
//    data['user2'] =  u2Name;
    data['owner'] = [uName, u2Name];
    data['prodName'] = prodName;
    data['prodUrl'] = prodUrl;
    data['ctime'] = Timestamp.now();

    String chatID = uID.toString()+u2ID.toString()+prodID.toString();

//    return _firestore.collection("users").document(uID).collection("chats").document(chatID).setData(data);
    return _firestore.collection("chats").document(chatID).setData(data);


  }

  Stream<QuerySnapshot> getMessages(uID, chatID) {
    return _firestore.collection("chats").document(chatID).collection("messages").snapshots();

//    return _firestore.collectionGroup("chats").where("owner", arrayContains: "uID").getDocuments();

//    return _firestore.collection("users").document(uID).collection("chats").document(chatID).collection("messages").getDocuments();
  }

  Future<QuerySnapshot> getChats(uName) {
    return _firestore.collection("chats").where("owner", arrayContains: uName).getDocuments();
  }
//
  void sendMessage(chatID, message) {

    var documentReference = _firestore
        .collection('chats')
        .document(chatID)
        .collection("messages")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    _firestore.runTransaction((transaction) async {
      await transaction.set(documentReference, message.toJson());
    });

//    return _firestore.collection("chats").document(chatID).collection("messages").add(message);

  }




}