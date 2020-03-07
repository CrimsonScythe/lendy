import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/bloc.dart';
import 'package:lendy/src/screens/home_screen.dart';
import 'package:lendy/src/screens/login_screen.dart';

class SigninScreen extends StatefulWidget {
  final Bloc bloc = new Bloc();

  @override
  State<StatefulWidget> createState() {
    return SigninScreenState();
  }
}

class SigninScreenState extends State<SigninScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userID = "";

  @override
  void initState() {
    super.initState();

//    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser){
//      if (firebaseUser != null){
//
////        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
//      }
//    });
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Signup"),
//      ),
//      body: StreamBuilder(
//          stream: _auth.onAuthStateChanged,
//          builder: (context, snapshot) {
//            if (snapshot.hasData && !snapshot.hasError) {
////              Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);
//              return HomeScreen();
//            } else {
////              return LoginScreen();
////            return LoginScreen();
//            return Scaffold(
//              body:
//                             Container(
//                child: Column(
//                  children: <Widget>[
//                    emailField(widget.bloc),
//                    passwordField(widget.bloc),
////            forgotPasswor
////            passwordFieldRe(widget.bloc),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                    buttons(widget.bloc)
//                  ],
//                ),
//              ),
//            );
////               Container(
////                child: Column(
////                  children: <Widget>[
////                    emailField(widget.bloc),
////                    passwordField(widget.bloc),
//////            forgotPasswor
//////            passwordFieldRe(widget.bloc),
////                    SizedBox(
////                      height: 10.0,
////                    ),
////                    buttons(widget.bloc)
////                  ],
////                ),
////              );
//            }
//          }),
////      Container(
////        child: Column(
////          children: <Widget>[
////            emailField(widget.bloc),
////            passwordField(widget.bloc),
//////            forgotPasswor
//////            passwordFieldRe(widget.bloc),
////            SizedBox(
////              height: 10.0,
////            ),
////            buttons(widget.bloc)
////          ],
////        ),
////      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            emailField(widget.bloc),
            passwordField(widget.bloc),
//            forgotPasswor
//            passwordFieldRe(widget.bloc),
            SizedBox(
              height: 10.0,
            ),
            buttons(widget.bloc, context)
          ],
        ),
      ),
    );

  }

  Widget emailField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Enter email address',
              labelText: 'Email-address',
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePassword,
            decoration: InputDecoration(
                hintText: 'Enter password',
                labelText: 'Password',
                errorText: snapshot.error),
          );
        });
  }

  Widget buttons(Bloc bloc, BuildContext buildContext) {
    return StreamBuilder(
      stream: bloc.loginValid,
      builder: (context, snapshot1) {
        return StreamBuilder(
          stream: bloc.signInStatus,
          builder: (context, snapshot2) {
            if (!snapshot2.hasData || snapshot2.hasError) {
              return Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Login'),
                    color: Colors.blue,
                    onPressed: snapshot1.hasData && snapshot1.data
                        ? () {
                      signIn(bloc, buildContext);
                          }
                        : null,
                  ),
                  snapshot2.hasError
                      ? Text(
                          snapshot2.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Text("Forgot password?",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey)),
                    onTap: () {
                      Navigator.of(context).pushNamed("/forgotpass");
                    },
                  )
                  //TODO: memory leak above for GestureDetector?
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  void signIn(bloc, con) async{
    var isSignedin = await bloc.signIn();

    if (isSignedin){
//      Navigator.pushNamedAndRemoveUntil(con, newRouteName, predicate)
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      Navigator.pushNamed(con, '/home');
//
//      Navigator.pushnam(con,'/home', (Route<dynamic> route) => false);

    }

  }
}
