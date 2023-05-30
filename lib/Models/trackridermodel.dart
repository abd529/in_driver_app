import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RiderTrack {
  String? id;
  String? email;
  String? name;
  String? phone;

  RiderTrack({this.id = "", this.email = "", this.name = "", this.phone = ""});
  RiderTrack.fromSnapshot(DataSnapshot dataSnapshot) {
    Map<dynamic, String>? data = dataSnapshot.value as Map<dynamic, String>?;
    id = dataSnapshot.key;
    email = data!['email'];
    name = data['name'];
    phone = data['phone'];
  }
}
