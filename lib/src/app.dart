import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendy/resources/bloc_provider.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import 'package:lendy/src/blocs/provider.dart';
import 'package:lendy/src/screens/forgotpass_screen.dart';
import 'package:lendy/src/screens/lend.dart';
import 'package:lendy/src/screens/login_screen.dart';
import 'package:lendy/src/screens/price_screen.dart';
import 'package:lendy/src/screens/signin_screen.dart';
import 'package:lendy/src/screens/signup_screen.dart';

import 'screens/home_screen.dart';

class App extends StatelessWidget {

  final Widget defaultHome;

  const App({Key key, this.defaultHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: new ItemBloc(),
      child: MaterialApp(
        home: defaultHome,
        title: "App",
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomeScreen(),
          '/login': (BuildContext context) => new LoginScreen(),
          '/signup': (BuildContext context) => new SignupScreen(),
          '/signin': (BuildContext context) => new SigninScreen(),
          '/forgotpass' : (BuildContext context) => new ForgotPassScreen(),
          '/lend' : (BuildContext context) => new LendScreen(),
          '/price' : (BuildContext context) => new PriceScreen()
        },
      ),
    );
//    return MaterialApp(
//      home: defaultHome,
//      title: "App",
//      routes: <String, WidgetBuilder>{
//        '/home': (BuildContext context) => new HomeScreen(),
//        '/login': (BuildContext context) => new LoginScreen(),
//        '/signup': (BuildContext context) => new SignupScreen(),
//        '/signin': (BuildContext context) => new SigninScreen(),
//        '/forgotpass' : (BuildContext context) => new ForgotPassScreen(),
//        '/lend' : (BuildContext context) => new LendScreen(),
//        '/price' : (BuildContext context) => new PriceScreen()
//      },
//    );


  }


}
