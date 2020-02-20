import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'validators.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators {

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _passwordretype = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  //Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword)
  .doOnData((String c) {
    if (0 != _passwordretype.value.compareTo(c)) {

    }
  });

  Stream<String> get passwordretype=> _passwordretype.stream.transform(validatePasswordRetype)
  .doOnData((String c){
    if(0 != _password.value.compareTo(c)){
      _passwordretype.addError("Passwords do not match");
    }
  });

  Stream<bool> get signInStatus => _isSignedIn.stream;


  Stream<bool> get submitValid =>
    Rx.combineLatest3(email, password, passwordretype, (e, p, r) {

      if(_password.value == _passwordretype.value){
        return true;
      }

      if (!_passwordretype.hasValue || !_password.hasValue || !_email.hasValue){
        return false;
      }
      if (p == _password.value && r == _passwordretype.value){
        return true;
      } else {
        return false;
      }
    });


  //Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changePasswordRetype => _passwordretype.sink.add;
  Function(bool) get showProgressBar => _isSignedIn.add;

  register() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      showProgressBar(true);
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _email.value,
        password: _password.value,
      ))
          .user;
      if (user != null) {
//        setState(() {
//          _success = true;
//          _userEmail = user.email;
//          Navigator.of(context).pushNamedAndRemoveUntil(
//              '/home', (Route<dynamic> route) => false);
//
////        Navigator.of(context).pushReplacementNamed('/home');
//
//        });
      } else {
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text("Error occured, please try again later"),
//        ));
//        _success = false;
      }
    } catch (err) {
      _isSignedIn.addError(err);
      print(err);
//      setState(() {
//        _showLoading = false;
//        _error = true;
//      });
    }



  }



  dispose() {
    _email.drain();
    _email.close();
    _password.drain();
    _password.close();
    _passwordretype.drain();
    _passwordretype.close();
  }

}