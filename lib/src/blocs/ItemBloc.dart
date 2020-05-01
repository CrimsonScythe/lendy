import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lendy/resources/bloc_provider.dart';
import 'package:lendy/resources/location_provider.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/validators.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;


class ItemBloc extends Object with Validators {
  final List<File> photosList = <File>[];


  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _des = BehaviorSubject<String>();
  final _pic = BehaviorSubject<File>();
  final _drop = BehaviorSubject<String>();

  set title(value) {
    _title.sink.add(value);
  }

  final _piclist = BehaviorSubject<List<File>>();

  final _daily = BehaviorSubject<String>();
  final _weekly = BehaviorSubject<String>();
  final _monthly = BehaviorSubject<String>();
  final _deposit = BehaviorSubject<String>();

  final _showProgress = BehaviorSubject<bool>();

  final _firestore = BehaviorSubject<bool>();
  final _cloudstore = BehaviorSubject<bool>();

  final _uploadComplete = BehaviorSubject<bool>();

  Stream<String> get daily => _daily.stream
  .doOnData((String c){
    var val = (7 * int.parse(c)).ceil().toString();
    var val2 = (28 * int.parse(c)).ceil().toString();
    _weekly.sink.add(val);
    _monthly.sink.add(val2);
  });

  Stream<String> get weekly => _weekly.stream
  .doOnData((String c) {
    print('DATA ARRIVED!!!!');
  });

  Stream<String> get monthly => _monthly.stream
  .doOnData((String c){

  });


  Stream<String> get deposit => _deposit.stream.transform(validateDeposit);

  Stream<String> get title => _title.stream.transform(validateTitle)
  .doOnData((String c){
//    if (_des.toString().isEmpty){
//      print('des empty');
//
//    }
  });

  Stream<bool> get firestore => _firestore.stream;
  Stream<bool> get cloudstore => _cloudstore.stream;

  Stream<String> get drop => _drop.stream.transform(validateDrop);

  Stream<String> get des => _des.stream.transform(validateDes)
  .doOnData((String c){
//    if (_title.toString().isEmpty){
//      print('title empty');
//
//    }
  });

  Stream<File> get pic => _pic.stream.transform(validatePic);
//  Stream<ImageStream> get photo =>

  Stream<List<File>> get picList => _piclist.stream.transform(validatePicList);

  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeDes => _des.sink.add;

  Function(String) get changeDrop => _drop.sink.add;

  Function(File) get addPic => _pic.sink.add;

  Function(String) get changeDaily => _daily.sink.add;
  Function(String) get changeWeekly => _weekly.sink.add;
  Function(String) get changeMonthly => _monthly.sink.add;
  Function(String) get changeDeposit => _deposit.sink.add;



  Stream<bool> get nextValid => Rx.combineLatest4(title, des, picList,drop, (e,r,p,d) {

    if (photosList.length==0 || _des.value.isEmpty || _title.value.isEmpty
      || _drop.value=='Choose Category'){
      return false;
    } else {
      return true;
    }


  });

//  This stream should combine firestore and cloud storage tasks and return true,
//  only when both are finished with their tasks
  Stream<bool> get showProgress => _showProgress.stream;
//  Stream<bool> get showProgress => Rx.combineLatest2(firestore, cloudstore, (f,c) {
//    return (f==true && c==true) ? true : false;
//  });


  Stream<bool> get uploadComplete => Rx.combineLatest2(firestore, cloudstore, (f, c) {
    if (f==true && c==true){
      _showProgress.sink.add(false);
      return true;
    } else {
      return false;
    }

  });

//  Future<bool> getYolo() {
//    uploadComplete.
//    uploadComplete.listen((dat){
//
//    });
//  }


//  bool getStatus() async {
//    uploadComplete.listen((val){
//      return val;
//    });
//  }

  void fetchItems(item) async {

    _showProgress.sink.add(true);


    var fut = <Future>[];

    var list = List<File>();

    for (int i=0; i < item.urls.length; i++){
      var direc = await getApplicationDocumentsDirectory();
      var res = await http.get(item.urls[i]);
      var path = direc.path;
      var time = DateTime.now();
      var file = File('$path/$time'+i.toString()+'.png');
      var fileReal = await file.writeAsBytes(res.bodyBytes);

      list.add(fileReal);
    }

    setImage(list);
    _showProgress.sink.add(false);


  }

  void deleteItem(dID, imgNames) {
    _showProgress.sink.add(true);

    var futureList = _repository.deleteImage(imgNames);
    Future.wait(futureList)
    .whenComplete((){
      _cloudstore.sink.add(true);

      _repository.deleteItem(_repository.user_ID, dID, imgNames).whenComplete((){
        _firestore.sink.add(true);
      });

    });

  }

  void updateItem(docID, imgNames) {


    _showProgress.sink.add(true);

    var futureList = _repository.updateImage(_repository.user_ID, imgNames, photosList);
    Future.wait(futureList)
    .then((storageTaskSnapshot){
      _cloudstore.sink.add(true);

      var futureList2 = _repository.getDownloadURLs(storageTaskSnapshot);
      Future.wait(futureList2)
      .then((urlList){

        var future1 = _repository.updateItem(_repository.user_ID, docID, _drop.value, _title.value, _des.value,
            _daily.value, _weekly.value, _monthly.value, _deposit.value,
            urlList)
        // TODO: MOST IMPORTANT By design, connection state should be check on the homescreen because firebase
        // TODO: does not return an error
            .then((value) {
//          //:TODO check for errors here?
          _firestore.sink.add(true);

        })
            .catchError((err){
          print("error");
        });
      });
    });


  }

  void uploadItem() {
  // TODO: upload all images. get downloadurls create one doc with urls
    _showProgress.sink.add(true);

    // storage task first
    List imgNames = new List<String>();
    var time = DateTime.now().millisecondsSinceEpoch.toString();

    for (int i = 0; i < photosList.length; i++){
      imgNames.add(time+i.toString());
    }

    var futureList = _repository.uploadImage(_repository.user_ID, photosList, imgNames);
    var downloadURLs = [];
    Future.wait(futureList)
    .then((storageTaskSnapList){
      //: TODO check for errors here?
      _cloudstore.sink.add(true);
      // get URLs

      var futureList2 = _repository.getDownloadURLs(storageTaskSnapList);
      Future.wait(futureList2)
      .then((urlList) async {

        print("repo is"+_repository.user_Location.toString());

        if (_repository.user_Location==null){
          LocationProvider locationProvider = new LocationProvider();
          _repository.user_Location = await locationProvider.getLocation();
        }


        var future1 = _repository
            .uploadItem(_repository.user_ID, _drop.value, _title.value, _des.value, _daily.value,
            _weekly.value, _monthly.value, _deposit.value, urlList, imgNames, _repository.user_Location, _repository.userName, _repository.userProfileUrl)
        // TODO: MOST IMPORTANT By design, connection state should be check on the homescreen because firebase
        // TODO: does not return an error
            .then((value) {
//          //:TODO check for errors here?
          _firestore.sink.add(true);

        })
            .catchError((err){
          print("error");
        });

      });

    });

  }

  Stream<bool> get post => Rx.combineLatest4(daily, weekly, monthly, deposit, (d,w,m,de){

//    print('FDLGNSKNHSK');

//    print(_daily.value.empty);
    print(_weekly.value);

    if (_daily.value.isEmpty || _weekly.value.isEmpty || _monthly.value.isEmpty
    || _deposit.value.isEmpty){
//      print('KJDFNKSJDGH');
      return false;
    }

    return true;
  });

  void getImage() {
    _repository.getImage().then((value) {
      if (value!=null){ // only add image if not null
        photosList.add(value);
        _piclist.sink.add(photosList);
      }
    });
  }

  void takeImage() {
    _repository.takeImage().then((value) {
      if (value!=null) {
        photosList.add(value);
        _piclist.sink.add(photosList);
      }
    });
  }

  void setImage(List<File> pics) {

    pics.forEach((f){
      photosList.add(f);
    });
    _piclist.sink.add(photosList);

  }


  void deleteImage(index) {
//    print("length"+ photosList.length.toString());
    photosList.removeAt(index);
//    if (photosList.length==0){
//      _piclist.sink.addError("ERROR");
//    }
    _piclist.sink.add(photosList);
  }

  resetAll() {
    _title.value='';
    _des.value='';
    photosList.clear();
    _drop.value='Choose Category';
    _daily.value='';
    _weekly.value='';
    _monthly.value='';
    _deposit.value='';
    _firestore.value=false;
    _cloudstore.value=false;
    // added new below
  }

  reset() {
    _title.value='';
    _des.value='';
    photosList.clear();
//    _piclist.value=null;
    _drop.value='Choose Category';

//    photosList.clear();
//    _drop.value=null;
//    _drop.drain();
//    _piclist.value=null;
//    _piclist.drain();
//    _pic.value=null;
//    _pic.drain();
//    _des.value=null;
//    _des.drain();
//    _daily.value=null;
//    _daily.drain();
//    _weekly.value=null;
//    _weekly.drain();
//    _monthly.value=null;
//    _monthly.drain();
//    _deposit.value=null;
//    _deposit.drain();
//    _showProgress.drain();
//    _firestore.value=null;
//    _firestore.drain();
//    _cloudstore.value=null;
//    _cloudstore.drain();
  }


  dispose() async {
    // TODO: call close somewhere !
    print('CALLED 222');
//    photosList.clear();
//    _title.drain();
//    _des.drain();
//    _pic.drain();
//    _piclist.drain();
//    _drop.value=null;
//    _drop.drain();
//    _daily.drain();
//    _weekly.drain();
//    _monthly.drain();
//    _deposit.drain();
//    _showProgress.drain();
//    _firestore.value=null;
//    _firestore.drain();
//    _cloudstore.value=null;
//    _cloudstore.drain();

//    photosList.clear();
////    _title.value=null;
//    _title.drain();
////    _drop.value=null;
//    _drop.drain();
////    _piclist.value=null;
//    _piclist.drain();
////    _pic.value=null;
//    _pic.drain();
////    _des.value=null;
//    _des.drain();
////    _daily.value=null;
//    _daily.drain();
////    _weekly.value=null;
//    _weekly.drain();
////    _monthly.value=null;
//    _monthly.drain();
////    _deposit.value=null;
//    _deposit.drain();
//    _showProgress.drain();
////    _firestore.value=null;
//    _firestore.drain();
////    _cloudstore.value=null;
//    _cloudstore.drain();


  _title.value='';

//  _title.sink.add('Title cannot be empty');

  }

  set des(value) {
    _des.sink.add(value);
  }

  set drop(value) {
    _drop.sink.add(value);
  }

  set daily(value) {
    _daily.sink.add(value);
  }

  set weekly(value) {
    _weekly.sink.add(value);
  }

  set monthly(value) {
    _monthly.sink.add(value);
  }

  set deposit(value) {
    _deposit.sink.add(value);
  }
}
