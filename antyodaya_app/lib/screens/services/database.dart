import 'package:cloud_firestore/cloud_firestore.dart';

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
      String phoneno) async {
    return await users.doc(uid).set({
      'link': imagelink,
      'decription': description,
      'location': location,
      'phoneno': phoneno,
    }, SetOptions(merge: true)).then((_) {
      print("Success");
    });
  }
}
