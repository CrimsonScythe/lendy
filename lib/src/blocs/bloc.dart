import 'dart:async';
import 'validators.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators {

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _passwordretype = BehaviorSubject<String>();


  //Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get passwordretype=> _passwordretype.stream.transform(validatePasswordRetype)
  .doOnData((String c){
    if(0 != _password.value.compareTo(c)){
      _passwordretype.addError("Passwords do not match");
    }
  });

  Stream<bool> get submitValid =>
      Observable.combineLatest3(email, password, passwordretype, (e, p, r) => true);



  //Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changePasswordRetype => _passwordretype.sink.add;



  dispose() {



    _email.close();
    _password.close();
    _passwordretype.close();
  }

}