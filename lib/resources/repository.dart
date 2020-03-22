import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lendy/resources/firestore_provider.dart';
import 'package:lendy/resources/image_picker_provider.dart';

class Repository {

  static final Repository _repository = Repository._internal();

  final List<File> photosList = <File>[];


  factory Repository(){
    return _repository;
  }

  Repository._internal();

  final _firestoreProvider = FirestoreProvider();
  final _imagePickerProvider = ImagePickerProvider();

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

  //TODO: should be async await here?
  Future<File> getImage() async =>
      await _imagePickerProvider.getImage();

  Future<File> takeImage() async =>
      await _imagePickerProvider.takeImage();



}