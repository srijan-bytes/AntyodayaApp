// ignore: avoid_web_libraries_in_flutter

import 'package:antyodaya_app/screens/authentication/otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:antyodaya_app/screens/services/database.dart';
import 'package:antyodaya_app/screens/shared/loading.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password, _no, _address, _location;
  TextEditingController _controller = TextEditingController();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        //Creating User Database
        await DataBaseService(uid: user.uid).updateUsersData(
            _name, _email, _password, _address, _location, _no);
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      _formKey.currentState.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          await _auth.currentUser.updateProfile(displayName: _name);
        }
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
            title: Text('ERROR'),
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.yellow,
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
                              child: TextFormField(
                                  // ignore: missing_return
                                  validator: (input) {
                                    if (input.isEmpty) return 'Enter Name';
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  onSaved: (input) => _name = input.trim()),
                            ),
                            Container(
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
                            Container(
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
                            Container(
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
                            Container(
                              child: TextFormField(
                                  // ignore: missing_return
                                  validator: (input) {
                                    if (input.isEmpty) return 'Enter Address';
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Address',
                                      prefixIcon: Icon(Icons.home)),
                                  onSaved: (input) => _address = input.trim()),
                            ),
                            Container(
                              child: TextFormField(
                                  // ignore: missing_return
                                  validator: (input) {
                                    if (input.isEmpty)
                                      return 'Share Your Location';
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Location',
                                      prefixIcon: Icon(Icons.location_city)),
                                  onSaved: (input) => _location = input.trim()),
                            ),
                            Container(
                              child: TextFormField(
                                  // ignore: missing_return
                                  validator: (input) {
                                    if (input.isEmpty)
                                      return 'Enter Phone Number';
                                  },
                                  maxLength: 10,
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      prefix: Text("+91 "),
                                      labelText: 'Phone Number',
                                      prefixIcon: Icon(Icons.phone)),
                                  onSaved: (input) => _no = input.trim()),
                            ),
                            SizedBox(height: 20),
                            // ignore: deprecated_member_use
                            // ignore: deprecated_member_use
                            RaisedButton(
                              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                              onPressed: () {
                                SignUp();
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         Otp(_controller.text)));
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
