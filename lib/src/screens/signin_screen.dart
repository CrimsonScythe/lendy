import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SigninScreenState();
  }

}

class SigninScreenState extends State<SigninScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userID = "";

  bool _error = false;
  String _userEmail;

  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signin"),
        ),
        body: Form(

            key: _formKey,
            child: Column(

              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                Container(
                  child: !_showLoading?RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _signIn();
                        setState(() {
                          _error = false;
                          _showLoading = true;
                        });
                      }
                    },
                    child: const Text('Sign in'),
                  ): CircularProgressIndicator(),
                ),
                Container(
                  child: _error?Text("Incorrect username or password.\nPlease try again.",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),):null,
                )
              ],
            )
        )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {


    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;


    if (user != null) {
      setState(() {
        _showLoading = false;
        _error = false;
        _userEmail = user.email;
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

//        Navigator.of(context).pushReplacementNamed('/home');
      });
    } else {
      print("fffff");
      setState(() {
        _showLoading = false;
        _error = true;
      });

    }

    }
    catch (err) {
      print("ERROR");
      setState(() {
        _showLoading = false;
        _error = true;
      });
    }
  }

}