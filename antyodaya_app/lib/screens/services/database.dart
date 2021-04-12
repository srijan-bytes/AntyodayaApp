//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBaseService {
  final String uid;

  //Users
  DataBaseService({this.uid});
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  Future updateUsersData(String name, String email, String password,
      String address, String location, String phoneno) async {
    return await users.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'location': location,
      'phoneno': phoneno,
    }, SetOptions(merge: true)).then((_) {
      print("Success");
    });
  }

  //Posts
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');
  Future updatePostData(String imagelink, String description, String location,
      String phoneno, String name) async {
    return await posts.doc(uid).set({
      'link': imagelink,
      'description': description,
      'location': location,
      'phoneno': phoneno,
      'name': name,
    }, SetOptions(merge: true)).then((_) {
      print("Success");
    });
  }

  Future getPostsList() async {
    List itemsList = [];
    try {
      await posts.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
