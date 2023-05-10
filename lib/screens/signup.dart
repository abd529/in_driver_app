// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/mybutton.dart';
import '../models/registerviewmodel.dart';
import '../widgets/myColors.dart';
import '../widgets/myTextField.dart';
import '../widgets/pickimages.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  RegisterViewModel registerVM = RegisterViewModel();
  //controllers for managing data
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  Uint8List? _image;
//key for handling auth
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  bool _isSigningUp = false;
  final RegisterViewModel _registerVM = RegisterViewModel();

  bool _isChecked = false;
  String? _errorMessage;

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _mobilecontroller.dispose();
    _lastnameController.dispose();
    _fnameController.dispose();
    super.dispose();
  }

  String ErrorMessage = "";

//function to select image of user
  void selectimage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Stack(children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/blankimage.jpg'),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 75,
                          child: IconButton(
                              onPressed: () {
                                selectimage();
                              },
                              icon: Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                              )))
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    //textEditingController: controller.fname,

                    textEditingController:_fnameController,
                    hintText: "First Name*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    textEditingController: _lastnameController,
                    hintText: "Last Name*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textEditingController: _emailController,
                    hintText: "Email Address*",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.length < 11) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                    textEditingController: _passController,
                    hintText: "Mobile Number*",
                    textInputType: TextInputType.number,
                    action: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    textEditingController: _passController,
                    hintText: "Password",
                    textInputType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: _onCheckboxChanged,
                      ),
                      Text(
                        "I accept all terms and conditions ",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: _isSigningUp
                  //       ? null
                  //       : () async {
                  //           if (formGlobalKey.currentState!.validate()) {
                  //             setState(() {
                  //               _isSigningUp = true;
                  //             });
                  //             // call Firebase function to sign up user
                  //             bool isRegistered = false;
                  //             isRegistered = await _registerVM.register(
                  //                 _emailController.text.trim(),
                  //                 _passController.text.trim(),
                  //                 _fnameController.text.trim(),
                  //                 _lastnameController.text.trim(),
                  //                 _mobilecontroller.text.trim());
                  //             if (isRegistered) {
                  //               var userId =
                  //                   FirebaseAuth.instance.currentUser!.uid;
                  //               await FirebaseFirestore.instance
                  //                   .collection("UsersData")
                  //                   .doc(userId)
                  //                   .set({
                  //                 "First Name": _fnameController.text.trim(),
                  //                 "Last Name": _lastnameController.text.trim(),
                  //                 "Email": _emailController.text.trim(),
                  //                 "Mobile": _mobilecontroller.text.trim()
                  //               });
                  //               Navigator.pushAndRemoveUntil(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (ctx) => const Home()),
                  //                   (Route<dynamic> route) => false);
                  //             }
                  //           }
                  //         },
                  //   child: Container(
                  //     height: 60,
                  //     width: 300,
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [gd2, gd1],
                  //         ),
                  //         borderRadius: BorderRadius.circular(20)),
                  //     child: Center(
                  //       child: _isSigningUp
                  //           ? const CircularProgressIndicator()
                  //           : const Text(
                  //               'Sign Up',
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: _isSigningUp
                  //       ? null
                  //       : () async {
                  //           if (formGlobalKey.currentState!.validate()) {
                  //             setState(() {
                  //               _isSigningUp = true;
                  //             });
                  //             // call Firebase function to sign up user
                  //             bool isRegistered = false;
                  //             isRegistered = await _registerVM.register(
                  //                 _emailController.text.trim(),
                  //                 _passController.text.trim(),
                  //                 _fnameController.text.trim(),
                  //                 _lastnameController.text.trim(),
                  //                 _mobilecontroller.text.trim());
                  //             if (isRegistered) {
                  //               print("register");
                  //               var userId =
                  //                   FirebaseAuth.instance.currentUser!.uid;
                  //               await FirebaseFirestore.instance
                  //                   .collection("UsersData")
                  //                   .doc(userId)
                  //                   .set({
                  //                 "First Name": _fnameController.text.trim(),
                  //                 "Last Name": _lastnameController.text.trim(),
                  //                 "Email": _emailController.text.trim()
                  //               });

                  //               print("user is stored");
                  //               Navigator.pushAndRemoveUntil(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (ctx) => const Home()),
                  //                   (Route<dynamic> route) => false);
                  //             } else {
                  //               print(_registerVM.message);
                  //             }
                  //           }
                  //         },
                  //   child: _isSigningUp
                  //       ? const CircularProgressIndicator()
                  //       : const Text('Sign Up'),
                  // ),
                  MyCustomButton(
                      title: "Sign Up ",
                      borderrad: 25,
                      onaction: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          if (_isChecked == true) {
                            bool isRegistered = false;
                            isRegistered = await registerVM.register(
                                _mobilecontroller.text.trim(),
                              _emailController.text.trim(),
                                _passController.text.trim(),
                                _fnameController.text.toString(),
                                _lastnameController.text.trim());
                            if (isRegistered) {
                              final userId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .set({})
                                  .whenComplete(() => Fluttertoast.showToast(
        msg: "Authenticated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    )).catchError((error, stackTrace) {
                               Fluttertoast.showToast(
        msg: "Error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
                              });
                            }

                            // Get.to(() => Home());
                          }
                        }
                      },
                      //     FirebaseAuthMethod().signupUser(
                      //         email: _emailController.text,
                      //         fname: _fnameController.text,
                      //         lname: _lastnameController.text,
                      //         mobilenum: _mobilecontroller.text,
                      //         pass: _passController.text,
                      //         //     file: _image!);
                      //         Get.to(() => Home()));
                      //     _showetoast("Signup Successfully");
                      //   } else
                      //     _showetoast(
                      //         "Please Accept our terms and conditions");
                      // }

                      color1: gd2,
                      color2: gd1,
                      width: MediaQuery.of(context).size.width - 40),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Or"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image(
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                            image: AssetImage('assets/facebook.png')),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // User? user =
                          //     await FirebaseAuthMethod().signInWithGoogle();
                          // if (user != null) {
                          //   await FirebaseAuthMethod().addUserToFirestore(user);
                          // }

                          // FirebaseAuthMethod().signInWithGoogle();
                         // final googleSignIn = GoogleSignIn();
                         // final googleUser = await googleSignIn.signIn();
                        //  final googleAuth = await googleUser!.authentication;

                          // final credential = GoogleAuthProvider.credential(
                          //   accessToken: googleAuth.accessToken,
                          //   idToken: googleAuth.idToken,
                          // );

                          // final userCredential = await FirebaseAuth.instance
                          //     .signInWithCredential(credential);

                          // final user = userCredential.user;
                          // final displayName = user!.displayName;
                          // final email = user.email;

                          // Save user data to Firestore
                          // FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(user.uid)
                          //     .set({
                          //   'First Name': displayName,
                          //   'Email': email,
                          //   // Add more fields as needed
                          // });
                        },
                        child: Image(
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                            image: AssetImage('assets/google.png')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}