import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc extends Object with Validators{

  final List<File> photosList = <File>[];

  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _des = BehaviorSubject<String>();
  final _pic = BehaviorSubject<File>();

  Stream<String> get title => _title.stream.transform(validateTitle);
  Stream<String> get des => _des.stream.transform(validateDes);
  Stream<File> get pic => _pic.stream.transform(validatePic);
//  Stream<ImageStream> get photo =>

  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeDes => _des.sink.add;

  Function(File) get addPic => _pic.sink.add;

//  Stream<bool> get nextValid => Rx.combineLatest3(title, des, photo, (e,r,p) => true);

  void getImage() {
    _repository.getImage()
    .then((value){
      _pic.sink.add(value);
      photosList.add(value);
    });
  }

  void takeImage() {
    _repository.takeImage()
        .then((value){
      _pic.sink.add(value);
      photosList.add(value);
    });
  }

  dispose() async {
    _title.drain();
    _title.close();
    _des.drain();
    _des.close();
    _pic.drain();
    _pic.close();
  }

}