//import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'services/database.dart';

final CollectionReference postsRef =
    FirebaseFirestore.instance.collection('Posts');
final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('Users');

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String name, email, phone, address;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  Position _currentPosition;
  String _currentAddress;
  String description;
  double latitude, longitude;

  getUser() {
    //getting user id from database, cloud firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      user = auth.currentUser;
    }
  }

  Future getUserInfo() async {
    //Extracting user info from firestore...
    //to get user information
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
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

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    getUserInfo();
    super.initState();
  }

  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  var storageRef = FirebaseStorage.instance.ref();
  File _image;
  final picker = ImagePicker();
  bool isUploading = false;
  String postId = Uuid().v4();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Select image from gallery"),
                onPressed: getImage,
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Colors.blueAccent,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/dark_bg.jpg'), fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 400.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                    color: Colors.deepPurple,
                    onPressed: () => selectImage(context),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      _image = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imagefile = Im.decodeImage(_image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imagefile, quality: 85));
    setState(() {
      _image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    String url;
    UploadTask uploadTask = storageRef
        .child("Posts")
        .child(user.uid)
        .child("post_$postId.jpg")
        .putFile(imageFile);
    await uploadTask.whenComplete(() async {
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });

    return url;
  }

  _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (_currentPosition != null) {
        longitude = _currentPosition.longitude;
        latitude = _currentPosition.latitude;
      }
      print('$latitude $longitude');
    } catch (e) {
      print(e);
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_image);
    // await DataBaseService(uid: widget.currentUser.uid)
    //     .updatePostData(mediaUrl, "", "", "");

    User firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
      });
    }

    await DataBaseService(uid: user.uid).updatePostData(
        mediaUrl, description, latitude, longitude, phone, name);
    Navigator.pop(context);
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        // ignore: missing_required_param
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: clearImage,
        ),
        title: Text(
          "Description",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: isUploading ? null : () => handleSubmit(),
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ))
        ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(_image),
                  )),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250,
              child: TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(
                  hintText: "Write Description ....",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
                controller: captionController,
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              label: Text(
                "Use current location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.blue,
              onPressed: () {
                _getCurrentLocation();
              },
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image == null ? buildSplashScreen() : buildUploadForm();
  }
}
