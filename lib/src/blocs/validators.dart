import 'dart:async';

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
        if (password.length > 3){
          sink.add(password);
        } else {
          sink.addError('Password is too short.');
        }
      }
  );


  final validatePasswordRetype = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if (password.length > 3){
          sink.add(password);
        } else {
          sink.addError('Password is too short.');
        }
      }
  );


}