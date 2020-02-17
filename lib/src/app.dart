import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/provider.dart';
import 'package:lendy/src/screens/login_screen.dart';
import 'package:lendy/src/screens/signin_screen.dart';
import 'package:lendy/src/screens/signup_screen.dart';

import 'screens/home_screen.dart';

class App extends StatelessWidget {

  final Widget defaultHome;

  const App({Key key, this.defaultHome}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        title: "App",
        home: defaultHome,
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomeScreen(),
          '/login': (BuildContext context) => new LoginScreen(),
          '/signup': (BuildContext context) => new SignupScreen(),
          '/signin': (BuildContext context) => new SigninScreen()
        },
      ),
    );

    //    new MaterialApp(
//      title: "App",
//      home: _defaultHome,
//      routes: <String, WidgetBuilder>{
//        '/home': (BuildContext context) => new HomeScreen(),
//        '/login': (BuildContext context) => new LoginScreen(),
//        '/signup': (BuildContext context) => new SignupScreen(),
//        '/signin': (BuildContext context) => new SigninScreen()
//      },
//    )

  }

}
