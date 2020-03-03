import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendy/src/blocs/bloc.dart';

class ForgotPassScreen extends StatefulWidget{

  final Bloc bloc = Bloc();

  @override
  State<StatefulWidget> createState() {
    return ForgotPassScreenState();
  }

}

class ForgotPassScreenState extends State<ForgotPassScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            emailField(widget.bloc),
//            passwordField(widget.bloc),
//            forgotPasswor
//            passwordFieldRe(widget.bloc),
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
  void initState() {
    super.initState();
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

  Widget buttons(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot1) {
        return StreamBuilder(
          stream: bloc.signInStatus,
          builder: (context, snapshot2) {
            if (!snapshot2.hasData || snapshot2.hasError) {
              return Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Reset password'),
                    color: Colors.blue,
                    onPressed: snapshot1.hasData
                        ? () {
                      bloc.forgotPassword();
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


}