import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
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
}
