import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String role;
  const UserModel(
      {this.id,
      required this.email,
      required this.fname,
      required this.lname,
      required this.phone,
      required this.role
      });

  toJson() {
    return {
      'First Name': fname,
      'last name': lname,
      'Email': email,
      'Phone': phone,
    };
  }

  //map for fecthing users from firestore
  factory UserModel.fromSnapshot(
      DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return UserModel(
        id: document.id,
        email: data['Email'],
        fname: data['First Name'],
        lname: data['Last Name'],
        phone: data['Phone'],
        role: data['Role']
        );
  }
}
