// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login.dart';
import '../widgets/myColors.dart';
import '../widgets/mybutton.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    print('object');
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;
  int check = 0;
  String name = "name";
  String email = "example@gmail.com";
  String phone = 'null';

  void getInfo() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      print("ok");
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        name = data?["First Name"];
        email = data?["email"];
        //phone = data?["Phone"];
      });
    }
    print(userId);
  }
  // double num = 0;
  // void getEmissionLevel(BuildContext context) async {
  //   //double emission = 0;
  //   var collection = FirebaseFirestore.instance.collection('users');
  //   var docSnapshot = await collection.doc(userid).get();
  //   if (docSnapshot.exists) {
  //     print("object");
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     var value1 = data?["Email"];
  //     var value2 = data?["Phone"];
  //     print(value1);
  //     setState(() {
  //       email = value1;
  //       phone = value2;
  //     });
  //   }
  // }
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // void getCurrentUserEmail() {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     String email = user.email.toString();
  //     print('User email: $email');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getInfo());
      check++;
    }
    // final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
        title: Text(
          name,
          style: TextStyle(fontSize: 26, color: appbartitle),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              CupertinoIcons.settings,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(children: [
                const CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.add),
                ),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 40,
            ),
            Center(
              child: Text(
                name,
                //                   user!.email,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: appbg, borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: Icon(Icons.mark_email_read_sharp),
                      title: Text(
                        email,
                        style: TextStyle(fontSize: 14),
                      ),
                    )),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: appbg, borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: Icon(Icons.phone_callback_sharp),
                      title: Text(
                        phone,
                        style: TextStyle(fontSize: 14),
                      ),
                    )),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            InkWell(
              onTap: () {
                signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        //signOut();
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: red,
                        size: 40,
                      )),
                  const Text(
                    "Log out",
                    style: TextStyle(
                        color: red, fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
//         body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SingleChildScrollView(
//               child: StreamBuilder(
// //                future: controller.getUserData(),
//                 stream: FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(documentId)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     if (snapshot.hasData) {
//                       final data =
//                           snapshot.data!.data() as Map<String, dynamic>;
//                       final email = data['Email'] as String?;
//                       print(email);
//                       // UserModel userdata = snapshot.data as UserModel;
//                       return Column(
//                         children: [
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Center(
//                             child: Stack(children: [
//                               const CircleAvatar(
//                                 radius: 80,
//                                 backgroundImage: AssetImage('assets/dp.jpg'),
//                               ),
//                             ]),
//                           ),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 1 / 40,
//                           ),
//                           Text(
//                             fname,
//                             //                   user!.email,
//                             style: TextStyle(
//                                 fontSize: 40, fontWeight: FontWeight.w400),
//                           ),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 1 / 20,
//                           ),
//                           TextFormField(
//                             initialValue: documentId,
//                             // user.email.toString(),
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           TextFormField(
//                             initialValue: email,
//                             // user.email.toString(),
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           SizedBox(
//                             height:
//                                 MediaQuery.of(context).size.height * 1 / 7.5,
//                           ),
//                           MyCustomButton(
//                               title: "Edit Profile",
//                               borderrad: 25,
//                               onaction: () {
//                                 Get.to(() => EditProfile());
//                               },
//                               color1: gd2,
//                               color2: gd1,
//                               width: MediaQuery.of(context).size.width - 40),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     // FirebaseAuthMethod().signOut();
//                                   },
//                                   icon: Icon(
//                                     Icons.logout_rounded,
//                                     color: red,
//                                     size: 40,
//                                   )),
//                               const Text(
//                                 "Log out",
//                                 style: TextStyle(
//                                     color: red,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           )
//                         ],
//                       );
//                     } else if (snapshot.hasError) {
//                       return Center(
//                         child: Text(snapshot.error.toString()),
//                       );
//                     } else {
//                       return Center(
//                         child: Text("Something went wrong"),
//                       );
//                     }
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             )));
    );
  }
}
