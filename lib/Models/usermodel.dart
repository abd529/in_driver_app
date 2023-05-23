import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fname;
  final String lname;
  final String pass;
  final String phone;
  final String email;
  const UserModel(
      {this.id,
      required this.email,
      required this.fname,
      required this.lname,
      required this.pass,
      required this.phone});

  toJson() {
    return {
      'First Name': fname,
      'last name': lname,
      'Email': email,
      'Password': pass,
      'Phone': phone,
    };
  }

  //map for fecthing users from firestore
  factory UserModel.fromSnapshot(
      DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return UserModel(
        id: document.id,
        email: data['email'],
        fname: data['First Name'],
        lname: data['Last Name'],
        pass: "******",
        phone: data['phone']);
  }
}
