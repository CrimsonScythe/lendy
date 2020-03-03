import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  

  Widget _defaultHome = LoginScreen();

//  bool _result1 = await _googleSignIn.isSignedIn();
  FirebaseUser _result2 = await _auth.currentUser();

//  if (_result1 || _result2 != null) {
//    _defaultHome = new HomeScreen();
//  }

  if (_result2 != null){
    _defaultHome = new HomeScreen();
  }

  runApp(
    // line below was first
//    new App(defaultHome: _defaultHome)
    new MaterialApp(
      title: "App",
      home: App(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomeScreen(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/signup': (BuildContext context) => new SignupScreen(),
        '/signin': (BuildContext context) => new SigninScreen()
      },
    )
  );
}