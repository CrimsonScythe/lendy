import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/provider.dart';
import 'package:lendy/src/screens/forgotpass_screen.dart';
import 'package:lendy/src/screens/login_screen.dart';
import 'package:lendy/src/screens/signin_screen.dart';
import 'package:lendy/src/screens/signup_screen.dart';

import 'screens/home_screen.dart';

class App extends StatelessWidget {

  final Widget defaultHome;

  const App({Key key, this.defaultHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot){
        print("logged in");
        if (snapshot.connectionState == ConnectionState.active){
          FirebaseUser user = snapshot.data;
          if (user == null){
            return LoginScreen();
          }
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
//    return Provider(
//      child: MaterialApp(
//        title: "App",
//        home: defaultHome,
//        routes: <String, WidgetBuilder>{
//          '/home': (BuildContext context) => new HomeScreen(),
//          '/login': (BuildContext context) => new LoginScreen(),
//          '/signup': (BuildContext context) => new SignupScreen(),
//          '/signin': (BuildContext context) => new SigninScreen(),
//          '/forgotpass' : (BuildContext context) => new ForgotPassScreen(),
//        },
//      ),
//    );

  }

//  @override
//  Widget build(BuildContext context) {
//
//    return Provider(
//      child: MaterialApp(
//        title: "App",
//        home: defaultHome,
//        routes: <String, WidgetBuilder>{
//          '/home': (BuildContext context) => new HomeScreen(),
//          '/login': (BuildContext context) => new LoginScreen(),
//          '/signup': (BuildContext context) => new SignupScreen(),
//          '/signin': (BuildContext context) => new SigninScreen(),
//          '/forgotpass' : (BuildContext context) => new ForgotPassScreen(),
//        },
//      ),
//    );
//
//  }

}
