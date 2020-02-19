import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/bloc.dart';
import 'package:lendy/src/blocs/provider.dart';

class SignupScreen extends StatelessWidget {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final TextEditingController _passwordController2 = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userID = "";

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            emailField(bloc),
            passwordField(bloc),
            passwordFieldRe(bloc),
            SizedBox(
              height: 10.0,
            ),
            button(bloc)
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

  Widget passwordFieldRe(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordretype,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePasswordRetype,
            decoration: InputDecoration(
                hintText: 'Retype password',
                labelText: 'Password',
                errorText: snapshot.error),
          );
        });
  }

  Widget button(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
            child: Text('Register'),
            color: Colors.blue,
            //if true
            onPressed: snapshot.hasData
                ? () {
//            bloc.showProgressBar(true);
                    bloc.register();
                  }
                : null);
      },
    );
  }

  Widget buttons(Bloc bloc) {
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
                    onPressed: snapshot1.hasData
                        ? () {
                      bloc.register();
                    }
                        : null,
                  ),
                  snapshot2.hasError ? Text("ee") : Container()
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
            return buttons(bloc);
          } else {
            return CircularProgressIndicator();
          }
        });


  }

/