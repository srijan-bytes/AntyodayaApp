import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

var ref = FirebaseStorage.instance.ref();
CollectionReference postref = FirebaseFirestore.instance.collection('posts');

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assests/images/upload.svg', height: 260.0),
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
    UploadTask task = ref.child("post_$postId.jpg").putFile(imageFile);
    await task.whenComplete(() {
      url = ref.getDownloadURL() as String;
    });
    return url;
  }

  createPostInFirestore(
      {String mediaUrl, String location, String description}) {
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "postId": postId,
    });
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "mediaUrl": mediaUrl,
    });
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "ownerId": widget.currentUser.uid,
    });
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "username": widget.currentUser.displayName,
    });
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "description": description,
    });
    postref
        .doc(widget.currentUser.uid)
        .collection("userposts")
        .doc(postId)
        .set({
      "location": location,
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_image);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: descriptionController.text,
    );
    descriptionController.clear();
    locationController.clear();
    setState(() {
      _image = null;
      isUploading = false;
    });
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
                controller: descriptionController,
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
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
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
              onPressed: () => print("get user location"),
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
