import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc extends Object with Validators {


  final List<File> photosList = <File>[];

  final _repository = Repository();
  final _title = BehaviorSubject<String>.seeded('');
  final _des = BehaviorSubject<String>.seeded('');
  final _pic = BehaviorSubject<File>();
  final _drop = BehaviorSubject<String>();
  final _piclist = BehaviorSubject<List<File>>();

  Stream<String> get title => _title.stream.transform(validateTitle)
  .doOnData((String c){
//    if (_des.toString().isEmpty){
//      print('des empty');
//
//    }
  });

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


  Stream<bool> get nextValid => Rx.combineLatest4(title, des, picList,drop, (e,r,p,d) {

    if (photosList.length==0 || _des.value.isEmpty || _title.value.isEmpty
      || _drop.value=='Choose Category'){
      return false;
    } else {
      return true;
    }
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

  void deleteImage(index) {
    print("length"+ photosList.length.toString());
    photosList.removeAt(index);
//    if (photosList.length==0){
//      _piclist.sink.addError("ERROR");
//    }
    _piclist.sink.add(photosList);
  }

  dispose() async {
    _title.drain();
    _title.close();
    _des.drain();
    _des.close();
    _pic.drain();
    _pic.close();
    _piclist.drain();
    _piclist.close();
    _drop.drain();
    _drop.close();
  }
}
