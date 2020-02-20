import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/bloc.dart';
import 'package:lendy/src/blocs/provider.dart';

class SignupScreen extends StatefulWidget {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final TextEditingController _passwordController2 = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Bloc bloc = Bloc();

//  final bloc = Provider.of(context);

//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userID = "";

  bool _success;
  String _userEmail;
//
//  @override
//  Widget build(BuildContext context) {
//    final bloc = Provider.of(context);
//
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Signup"),
//      ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            emailField(bloc),
//            passwordField(bloc),
//            passwordFieldRe(bloc),
//            SizedBox(
//              height: 10.0,
//            ),
//            buttons(bloc)
//          ],
//        ),
//      ),
//    );
//  }



  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }


}


class SignUpScreenState extends State<SignupScreen>{



  @override
  void initState() {
    super.initState();

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
            buttons(widget.bloc)
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
            onPressed: snapshot.hasData && snapshot.data
                ? () {
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
                    onPressed: snapshot1.hasData && snapshot1.data
                        ? () {
                      bloc.register();
                    }
                        : null,
                  ),
                  snapshot2.hasError ? Text("Incorrect username or password.\nPlease try again."
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
            return buttons(bloc);
          } else {
            return CircularProgressIndicator();
          }
        });
  }




}
