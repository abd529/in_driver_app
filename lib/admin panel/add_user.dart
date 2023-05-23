import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  static const routeName = "add-user";
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Add user"),),
    );
  }
}