import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/models/registerviewmodel.dart';
import 'package:in_driver_app/models/usermodel.dart';

class AdminPanelScreen extends StatefulWidget {
  static const routName = "admin-panel";
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterViewModel registerVM = RegisterViewModel();

  Widget _buildList(QuerySnapshot<Object?>? snapshot) {
    if (snapshot!.docs.isEmpty) {
      return const Center(child: Text("No Users !"));
    } else {
      return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          final user = UserModel.fromSnapshot(doc);
          return _buildListItem(user);
        },
      );
    }
  }

  Widget _buildListItem(UserModel user) {
    return ListTile(
      title: Text(user.fname),
      
    );
  }

  
  void createUser(){}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Admin Panel", style: TextStyle(color: Colors.white),),),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   print("float");
      //   showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: const Text('Create a User'),
      //             content: Form(
      //               key: _formKey,
      //               child: Column(
      //                 children: [
      //                   const Text('Enter email and password for the user to creat an account'),
      //                 TextFormField()
      //                 ],
      //               ),
      //             ),
      //             actions: [
      //               TextButton(
      //                 child: const Text('Create User'),
      //                 onPressed: () {
                        
      //                   Navigator.of(context).pop();
      //                 },
      //               ),
      //               TextButton(onPressed: (){
      //                 Navigator.of(context).pop();
      //               }, child: const Text("Cancel", style: TextStyle(color: Colors.red),))
      //             ],
      //           );
      //         },
      //       );
      // }, child: const Icon(Icons.person_add),),
      body: SafeArea(child:
      SizedBox(
        width: double.infinity,
        child:  Column(
         children: [ 
          const Text("All Users", style: TextStyle(fontSize: 18),),
           StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("UsersData").snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return Expanded(child: _buildList(snapshot.data));
            })),
            ElevatedButton(onPressed: (){
                      FirebaseAuth.instance.signOut();   
                      Navigator.of(context).pushNamed(AuthHome.idScreen);
            }, child: const Text("Logout")),
            ElevatedButton(onPressed: (){
              print(FirebaseAuth.instance.currentUser!.uid);
            }, child: const Text("User")),
          ]
        ),
      )),
    );
  }
}