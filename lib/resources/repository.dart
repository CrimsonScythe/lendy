import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendy/resources/firestore_provider.dart';

class Repository {

  static final Repository _repository = Repository._internal();

  factory Repository(){
    return _repository;
  }

  Repository._internal();

  final _firestoreProvider = FirestoreProvider();
  String userID;

  Future<DocumentReference> uploadPic(uID, pID) =>
      _firestoreProvider.uploadPic(uID, pID);


  Future<void> addUser(uID) =>
      _firestoreProvider.addUser(uID);

  Future<FirebaseUser> getUser() async =>
      await FirebaseAuth.instance.currentUser();

  set user_ID(String id) {
    this.userID = id;
  }

  String get user_ID {
    return userID;
  }

}