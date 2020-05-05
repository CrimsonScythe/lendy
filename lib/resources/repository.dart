import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lendy/resources/chat_provider.dart';
import 'package:lendy/resources/firestore_provider.dart';
import 'package:lendy/resources/image_picker_provider.dart';
import 'package:lendy/resources/location_provider.dart';

class Repository {

  static final Repository _repository = Repository._internal();
//
//  final List<File> photosList = <File>[];
//  final List<File> photosList = <File>[];


  factory Repository(){
    return _repository;
  }

  Repository._internal();

  final _firestoreProvider = FirestoreProvider();
  final _imagePickerProvider = ImagePickerProvider();
  final _locationProvider = LocationProvider();
  final _chatProvider = ChatProvider();

  String userID;
  Position userLocation;
  String _userName;
  String _userPhotoUrl;

  set userName(String id) {
    this._userName = id;
  }

  String get userName {
    return _userName;
  }

  set userProfileUrl(String id) {
    this._userPhotoUrl = id;
  }

  String get userProfileUrl {
    return _userPhotoUrl;
  }


  void getLocation() {
    _locationProvider.getLocation()
    .then((loc){
      user_Location=loc;
    });
  }


//  Future<DocumentReference> uploadPic(uID, pID) =>
//      _firestoreProvider.uploadPic(uID, pID);

  Future<DocumentReference> uploadItem(uID,
      cat, title, des, daily, weekly, monthly, depo, urls, imgNames, loc, name, purl) =>
    _firestoreProvider.uploadItem(uID,
        cat, title, des, daily, weekly, monthly, depo, urls, imgNames, loc, name, purl);

  Future<void> updateItem(uID, dID, cat, title, des, daily, weekly, monthly, depo, urls)=>
    _firestoreProvider.updateItem(uID, dID, cat, title, des, daily, weekly, monthly, depo, urls);

  List<Future> updateImage(uID, imgNames, photos)=>
    _firestoreProvider.updateImage(uID, imgNames, photos);

  List<Future> uploadImage(uID, photos, imgNames) =>
      _firestoreProvider.uploadImage(uID, photos, imgNames);

  Future<void> addUser(uID) =>
      _firestoreProvider.addUser(uID);

  Future<void> createChat(uID, uName, u2ID, u2Name, prodID, prodUrl, prodName) =>
    _firestoreProvider.createChat(uID, uName, u2ID, u2Name, prodID, prodUrl, prodName);

  Future<FirebaseUser> getUser() async =>
      await FirebaseAuth.instance.currentUser();



  List<Future> getDownloadURLs(list) =>
    _firestoreProvider.downloadURLs(list);

  Future deleteItem(uID, dID, imgNames) =>
  _firestoreProvider.deleteItem(uID, dID, imgNames);

  List<Future> deleteImage(imgNames) =>
  _firestoreProvider.deleteImage(imgNames);

  set user_ID(String id) {
    this.userID = id;
  }

  String get user_ID {
    return userID;
  }

  set user_Location(Position position) {
    this.userLocation = position;
  }

  Position get user_Location {
    return userLocation;
  }

  //TODO: should be async await here?
  Future<File> getImage() async =>
      await _imagePickerProvider.getImage();

  Future<File> takeImage() async =>
      await _imagePickerProvider.takeImage();

  Future<QuerySnapshot> myList() =>
      _firestoreProvider.myList(user_ID);

  Future<QuerySnapshot> items() =>
      _firestoreProvider.getItems(_repository.user_ID);

  Stream<QuerySnapshot> getMessages(chatID) =>
      _firestoreProvider.getMessages(_repository.user_ID, chatID);

  List<ChatUser> createChatUsers(List<String> uID, List<String> name, List<String> purl) =>
      _chatProvider.createChatUsers(uID, name, purl);

  void sendMessage(chatID, message) =>
      _firestoreProvider.sendMessage(chatID, message);

  Future<QuerySnapshot> getChats(uName) =>
      _firestoreProvider.getChats(uName);

//  Stream<QuerySnapshot> myList() =>
//      _firestoreProvider.myList(user_ID);



}