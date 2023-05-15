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
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data['Email'],
        fname: data['First Name'],
        lname: data['last name'],
        pass: data['pass'],
        phone: data['Phone']);
  }
}
