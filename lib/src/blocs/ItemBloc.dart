import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lendy/resources/bloc_provider.dart';
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

  final _daily = BehaviorSubject<String>();
  final _weekly = BehaviorSubject<String>();
  final _monthly = BehaviorSubject<String>();
  final _deposit = BehaviorSubject<String>();



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

  void deleteImage(index) {
//    print("length"+ photosList.length.toString());
    photosList.removeAt(index);
//    if (photosList.length==0){
//      _piclist.sink.addError("ERROR");
//    }
    _piclist.sink.add(photosList);
  }

  dispose() async {
    // TODO: call close somewhere !
    print('CALLED 222');
    photosList.clear();
    _title.drain();
//    _title.close();
    _des.drain();
//    _des.close();
    _pic.drain();
//    _pic.close();
    _piclist.drain();
//    _piclist.close();
    _drop.value=null;
    _drop.drain();
//    _drop.close();
  }
}
