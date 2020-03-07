import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userID = "";

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 20.0,),
              Container(
                child: GoogleSignInButton(
                  onPressed: () async {
                    _signInWithGoogle();
                  },

                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                      ? 'Successfully signed in!'
                      : 'Sign in failed'),
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Container(
                child: FacebookSignInButton(
                  onPressed: () {

                  },

                ),

              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed('/signup');
                        },
                      child: const Text("Sign up"),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Container(
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signin');
                        },
                      child: const Text("Login"),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 25.0,),
            ],
          )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _signInWithGoogle() async {

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();


    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;


    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    setState(() {
      if (user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

//        Navigator.of(context).pushReplacementNamed('/home');
        _success = true;
        _userID = user.uid;
      } else {
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text("Error occured, please try again later"),
//        ));
        _success = false;
      }
    });
    }
    catch(error){
//      print(error);
    Fluttertoast.showToast(
        msg: "Error occured, please try again.",
        toastLength: Toast.LENGTH_LONG);
      _success = false;
    }

  }


}