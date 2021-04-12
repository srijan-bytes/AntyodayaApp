import 'dart:ui';

import 'package:antyodaya_app/screens/create_post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:antyodaya_app/screens/shared/loading.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      setState(() => loading = false);
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      _formKey.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        setState(() => loading = false);
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'ERROR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            content: Text(errormessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 180,
                    // child: Image(
                    //   image: AssetImage("images/login.jpg"),
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.blue,
                            child: TextFormField(
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.isEmpty) return 'Enter Email';
                                },
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email)),
                                onSaved: (input) => _email = input.trim()),
                          ),
                          SizedBox(height: 20),
                          Container(
                            color: Colors.amberAccent,
                            child: TextFormField(
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.length < 6)
                                    return 'Provide Minimum 6 Character';
                                },
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                onSaved: (input) => _password = input.trim()),
                          ),
                          SizedBox(height: 20),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                            onPressed: login,
                            child: Text('LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Create an Account?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    onTap: navigateToSignUp,
                  )
                ],
              ),
            ),
          ));
  }
}
