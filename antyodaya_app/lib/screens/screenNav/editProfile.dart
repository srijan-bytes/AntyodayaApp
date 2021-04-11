import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile(
      this.currentUserId); // constructor taking currentUserId as parameter

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String uId,
      name = "",
      phone = '',
      email = "",
      address = ""; //default values for the fields...
  String _imageUrl, profImagePath;
  bool isLoading = false;
  User user;
  TextEditingController _emailController;
  TextEditingController _usernameController;
  TextEditingController _addController;

  bool _isEditingText = false;
  bool _isEditingUser = false;
  bool _isEditingAdd = false;

  getUserId() {
    //getting user id from database, cloud firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      uId = auth.currentUser.uid;
    }
  }

  Future getUserInfo() async {
    //to get user information
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        name = snapshot["name"];
        email = snapshot["email"];
        phone = snapshot["phoneno"];
        address = snapshot["address"];
      });
    });
  }

  Future updateInfo() async {
    FirebaseFirestore.instance.collection('Users').doc(uId).update({
      'name': name,
      'email': email,
      'phoneno': phone,
      'address': address,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    getUserInfo();
    super.initState();
    //setting initial values of the fields...
    _emailController = TextEditingController(text: email);
    _usernameController = TextEditingController(text: name);
    _addController = TextEditingController(text: address);

    var ref =
        FirebaseStorage.instance.ref().child('Users/' + uId + '/profile.png');
    ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E29),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C37),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Color(0xFFFFF7C6),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontFamily: "Montserrat Bold",
              color: Color(0xFFE5E5E5),
              fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Color(0xFFFFF7C6),
            ),
            onPressed: () {
              updateInfo();
              uploadProfilePicture(
                  profImagePath); //saves and updates the changes in dashboard..
              Fluttertoast.showToast(
                  msg: "Changes Saved and Updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 12.0);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        // image: NetworkImage(
                        //     'https://googleflutter.com/sample_image.jpg'),
                        image: _imageUrl == null
                            ? NetworkImage(
                                'https://googleflutter.com/sample_image.jpg')
                            : NetworkImage(_imageUrl),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Color(0xFFFFC495),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        File image;
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);

                        setState(() {
                          if (pickedFile != null) {
                            image = File(pickedFile.path);
                            profImagePath = image.path.toString();
                          } else {
                            print('No image selected.');
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 350,
              child: Card(
                color: Color(0xFF2C2C37),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: _editUserNameField(),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        color: Colors.grey[600],
                        padding: EdgeInsets.only(left: 45, top: 4, right: 7),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Phone',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat Medium",
                                      color: Color(0xFFE5E5E5)),
                                ),
                                Text(
                                  phone,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Montserrat Medium",
                                      color: Color(0xFFE5E5E5)),
                                )
                              ],
                            ),
                            IconButton(
                              padding: EdgeInsets.only(
                                  left: 130, top: 4, right: 2, bottom: 2),
                              icon: Icon(
                                Icons.https,
                                color: Color(0xFF1E1E29),
                              ),
                              onPressed: () {},
                            ),
                          ], //Can't edit the phone number
                        ),
                      ),
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Can't edit the phone number!!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 12.0);
                      },
                    ),

                    //Let's Edit email......
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.only(left: 1, top: 4, right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      45.0, 10.0, 10.0, 0.0),
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat Medium",
                                        color: Color(0xFFCA9367)),
                                  ),
                                ),
                              ],
                            ),
                            _editEmailTextField(),
                          ],
                        ),
                      ),
                      onTap: () async {},
                    ),

                    //Let's Edit address.....
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.only(left: 1, top: 4, right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      45.0, 10.0, 10.0, 0.0),
                                  child: Text(
                                    'Address',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat Medium",
                                        color: Color(0xFFCA9367)),
                                  ),
                                ),
                              ],
                            ),
                            _editAddTextField(),
                          ],
                        ),
                      ),
                      onTap: () async {},
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                'Tap on the fields to edit them',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Montserrat Medium",
                    color: Color(0xFFCA9367)),
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadProfilePicture(String imagePath) async {
    //uploading profile picture,specifying path
    File file = File(imagePath);
    try {
      await FirebaseStorage.instance
          .ref()
          .child('Users/' + uId + '/profile.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Widget _editEmailTextField() {
    //specifically for email edit.....
    if (_isEditingText)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: TextField(
            style: TextStyle(
              color: Color(0xFFE5E5E5),
              fontFamily: 'Montserrat Regular',
            ),
            onSubmitted: (newValue) {
              setState(() {
                email = newValue;
                _isEditingText = false;
              });
            },
            autofocus: true,
            controller: _emailController,
          ),
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: Text(
              _isEditingText ? _emailController.text : email,
              style: TextStyle(
                  color: Color(0xFFE5E5E5),
                  fontSize: 16.0,
                  fontFamily: "Montserrat Medium"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editUserNameField() {
    //specifically for Username edit.....
    if (_isEditingUser)
      return Center(
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFC495),
            fontFamily: 'Montserrat Regular',
          ),
          onSubmitted: (newValue) {
            setState(() {
              name = newValue;
              _isEditingUser = false;
            });
          },
          autofocus: true,
          controller: _usernameController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingUser = true;
        });
      },
      child: Text(
        _isEditingUser ? _usernameController.text : name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          fontFamily: "Montserrat Bold",
          color: Color(0xFFFFC495),
        ),
      ),
    );
  }

  //address...
  Widget _editAddTextField() {
    //specifically for email edit.....
    if (_isEditingAdd)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: TextField(
            style: TextStyle(
              color: Color(0xFFE5E5E5),
              fontFamily: 'Montserrat Regular',
            ),
            onSubmitted: (newValue) {
              setState(() {
                address = newValue;
                _isEditingAdd = false;
              });
            },
            autofocus: true,
            controller: _addController,
          ),
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingAdd = true;
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: Text(
              _isEditingAdd ? _addController.text : address,
              style: TextStyle(
                  color: Color(0xFFE5E5E5),
                  fontSize: 16.0,
                  fontFamily: "Montserrat Medium"),
            ),
          ),
        ],
      ),
    );
  }
}
