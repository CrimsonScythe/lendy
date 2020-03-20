import 'dart:async';
import 'dart:io';

import 'dart:math';

class Validators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
        if (RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)){
          sink.add(email);
        } else {
          sink.addError('Please enter a valid email address.');
        }
      }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if (password.length > 5){
          sink.add(password);
        } else {
          sink.addError('Password is too short.');
        }
      }
  );


  final validatePasswordRetype = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if (password.length > 5){
          sink.add(password);
        } else {
          sink.addError('Password is too short.');
        }
      }
  );

  final validateTitle = StreamTransformer<String, String>.fromHandlers(
    handleData: (title, sink) {
      if (title.length > 0){
        sink.add(title);
      } else {
        sink.addError('Title cannot be empty');
      }

      // for error:
    }
  );

  final validateDes = StreamTransformer<String, String>.fromHandlers(
      handleData: (des, sink) {

        //TODO: handle the case where there is a new line

        if (des.length > 0){
          sink.add(des);
        } else {
          sink.addError('Description cannot be empty');
        }

        //for error:
      }
  );

  final validatePic = StreamTransformer<File, File>.fromHandlers(
      handleData: (des, sink) {
        if (!des.existsSync()){
          sink.addError('Error reading file');
        } else {
          sink.add(des);
        }
        //for error:
      }
  );


  final validatePicList = StreamTransformer<List<File>, List<File>>.fromHandlers(
      handleData: (des, sink) {
        if (des==null || des.length==0){
          sink.addError('Please attach a picture');
        } else {
          sink.add(des);
        }
      }
  );

}