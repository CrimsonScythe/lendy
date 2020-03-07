import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lendy/src/blocs/bloc.dart';
import 'package:lendy/src/blocs/provider.dart';

class SignupScreen extends StatefulWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Bloc bloc = Bloc();

  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }

}


class SignUpScreenState extends State<SignupScreen>{

  @override
  void initState() {
    super.initState();
//
//    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser){
//      if (firebaseUser != null){
//
//        Fluttertoast.showToast(
//          msg: "Login successful!",
//          gravity: ToastGravity.BOTTOM,
//          toastLength: Toast.LENGTH_LONG
//        );
//
//
//
//        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      }
//    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            emailField(widget.bloc),
            passwordField(widget.bloc),
            passwordFieldRe(widget.bloc),
            SizedBox(
              height: 10.0,
            ),
            buttons(widget.bloc, context)
          ],
        ),
      ),
    );


  }


  @override
  void dispose() {

    widget.bloc.dispose();
    super.dispose();

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

  Widget passwordFieldRe(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: bloc.passwordretype,
              builder: (context, snapshot2){
                return TextField(
                  onChanged: bloc.changePasswordRetype,
                  decoration: InputDecoration(
                      hintText: 'Retype password',
                      labelText: 'Password',
                      errorText: (snapshot.data != null && snapshot.data)? null : snapshot2.error),
                );
              },

          );

        });
  }


  Widget buttons(Bloc bloc, BuildContext buildContext) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot1) {
        return StreamBuilder(
          stream: bloc.signInStatus,
          builder: (context, snapshot2) {
            if (!snapshot2.hasData || snapshot2.hasError) {
              return Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Register'),
                    color: Colors.blue,
                    onPressed: snapshot1.hasData && snapshot1.data
                        ? () {
                      register(bloc, buildContext);
                    }
                        : null,
                  ),
                  snapshot2.hasError ? Text(snapshot2.error.toString()
                    ,textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),) : Container()
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

  Widget submitButton(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.signInStatus,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return buttons(bloc, context);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void register(Bloc bloc, BuildContext buildContext) async {
    var isRegistered = await bloc.register();

    if (isRegistered){
//      Navigator.pushNamedAndRemoveUntil(con, newRouteName, predicate)
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      Navigator.pushNamed(con, '/home');
//
//      Navigator.pushnam(con,'/home', (Route<dynamic> route) => false);

    }
  }

}
