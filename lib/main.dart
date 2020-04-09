import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lendy/resources/repository.dart';
import 'package:lendy/src/screens/home_screen.dart';
import 'package:lendy/src/screens/signin_screen.dart';
import 'package:lendy/src/screens/signup_screen.dart';
import 'src/app.dart';
import 'src/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Repository _repo = Repository();

  

  Widget _defaultHome = LoginScreen();

  FirebaseUser _result2 = await _auth.currentUser();


  if (_result2 != null){
    // TODO: Could this be null? Do I need to null check this before assigning?
    _repo.user_ID = _result2.uid;
    _defaultHome = new HomeScreen();
  }

  runApp(

    new App(defaultHome: _defaultHome)
  );
}