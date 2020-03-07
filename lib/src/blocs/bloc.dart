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
    // empty
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

      print("email: "+ e);
      print("password: " + p);
      print("passwordretype: " + r);

      if (r == p){
        return true;
      } else {
        return false;
      }

    })
    .doOnEach(
        (event) {
          print("hello");
        }
    );

  Stream<bool> get loginValid => Rx.combineLatest2(email, password, (e, r)  => true);

  //Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changePasswordRetype => _passwordretype.sink.add;
  Function(bool) get showProgressBar => _isSignedIn.add;


  Future<bool> signIn() async {

    showProgressBar(true);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _email.value,
        password: _password.value,
      ))
          .user;


      if (user != null) {
        // Navigate to home screen
        return true;
//        setState(() {
//          _showLoading = false;
//          _error = false;
//          _userEmail = user.email;
//          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//
////        Navigator.of(context).pushReplacementNamed('/home');
//        });
      } else {
        return false;
      }

    }
    catch (err) {
      String error = "";

      switch (err.code){
        case "ERROR_INVALID_EMAIL":
          error = "Email address is invalid.\n Please try again.";
          break;
        case "ERROR_WRONG_PASSWORD":
          error = "Password is incorrect.\n Please try again.";
          break;
        case "ERROR_USER_NOT_FOUND":
          error = "Account is not registered.\n Please sign-up instead.";
          break;
        case "ERROR_USER_DISABLED":
          error = "Account is disabled.\n Please contact us via the app menu.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          error = "Too many log-in requests.\n Please try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          error = "Technical error.\n Please contact us via the app menu.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          error = "Network connection error.\n Please check your network connection and try again.";
          break;
        default:
          error = "Error occured.\n Please try again.";
          break;
      }

      _isSignedIn.addError(error);
      return false;
    }
  }

  Future<bool> register() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      showProgressBar(true);
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _email.value,
        password: _password.value,
      ))
          .user;
      if (user != null) {
        return true;

      } else {
        return false;

      }
    } catch (err) {

      String error = "";

      switch (err.code){
        case "ERROR_WEAK_PASSWORD":
          error = "Password must be atleast 6 characters.\n Pleas try again.";
          break;
        case "ERROR_INVALID_EMAIL":
          error = "Email or password is incorrect.\n Please try again.";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          error = "Account is already registered.\n Please log-in instead.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          error = "Network connection error.\n Please check your network connection and try again.";
          break;
        default:
          error = "Error occured.\n Please try again.";
          break;
      }

      _isSignedIn.addError(error);
      return false;

    }

  }

  forgotPassword() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    showProgressBar(true);


    try {
      await _auth.sendPasswordResetEmail(
          email: _email.value
      );
    } catch (err) {
      String error = "";

      switch (err.code){
        case "ERROR_INVALID_EMAIL":
          error = "Email address is invalid.\n Please try again.";
          break;
        case "ERROR_WRONG_PASSWORD":
          error = "Password is incorrect.\n Please try again.";
          break;
        case "ERROR_USER_NOT_FOUND":
          error = "Account is not registered.\n Please sign-up instead.";
          break;
        case "ERROR_USER_DISABLED":
          error = "Account is disabled.\n Please contact us via the app menu.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          error = "Too many log-in requests.\n Please try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          error = "Technical error.\n Please contact us via the app menu.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          error = "Network connection error.\n Please check your network connection and try again.";
          break;
        default:
          error = "Error occured.\n Please try again.";
          break;
      }

      _isSignedIn.addError(error);
      print(err.code);
    }

  }

  dispose() async {
    _email.drain();
    _email.close();
    _password.drain();
    _password.close();
    _passwordretype.drain();
    _passwordretype.close();
    _isSignedIn.drain();
    _isSignedIn.close();
  }

}