// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_driver_app/auth/auth_verifiy.dart';
import 'package:get/get.dart';
import 'package:in_driver_app/screens/home.dart';

import '../../widgets/mybutton.dart';
import '../Models/usermodel.dart';
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

  Future<void> signUp(String email, String password, String First_Name,
      String Last_Name, String Phone) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new document in the "users" collection with the user's data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'First Name': First_Name,
        'Last Name': Last_Name,
        'phone': Phone
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmailVerification()));
      Get.snackbar("Message", "You have been SIgnup");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Message", e.code);

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Message", e.code);

        print('The account already exists for that email.');
      }
    } catch (e) {
      Get.snackbar("Message", e.toString());

      print(e);
    }
  }

  void _submitForm() {
    String email = _emailController.text;
    String password = _passController.text;
    String Fname = _fnameController.text;
    String phone = _mobilecontroller.text;
    String lname = _lastnameController.text;

    signUp(email, password, Fname, phone, lname);
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
                              backgroundColor: Colors.grey.shade200,
                              radius: 50,
                              child: Icon(CupertinoIcons.person_alt_circle),
                            ),
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

                    textEditingController: _fnameController,
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
                    textEditingController: _mobilecontroller,
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
                  MyCustomButton(
                      title: "Sign Up ",
                      borderrad: 25,
                      onaction: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          if (_isChecked == true) {
                            _submitForm();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
