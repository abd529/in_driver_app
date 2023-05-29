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
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widgets/mybutton.dart';
import '../Models/usermodel.dart';
import '../models/registerviewmodel.dart';
import '../widgets/myColors.dart';
import '../widgets/myTextField.dart';
import 'login.dart';

// class SignupPage extends StatefulWidget {
//   static const String idScreen = 'signup';

//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   RegisterViewModel registerVM = RegisterViewModel();
//   //controllers for managing data
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _passController = TextEditingController();

//   final TextEditingController _fnameController = TextEditingController();
//   final TextEditingController _lastnameController = TextEditingController();
//   final TextEditingController _mobilecontroller = TextEditingController();
//   Uint8List? _image;
// //key for handling auth
//   final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
//   bool _isSigningUp = false;
//   final RegisterViewModel _registerVM = RegisterViewModel();

//   bool _isChecked = false;
//   String? _errorMessage;

//   void _onCheckboxChanged(bool? value) {
//     setState(() {
//       _isChecked = value ?? false;
//     });
//   }

//   void _showetoast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passController.dispose();
//     _mobilecontroller.dispose();
//     _lastnameController.dispose();
//     _fnameController.dispose();
//     super.dispose();
//   }

//   String ErrorMessage = "";

// //function to select image of user

//   Future<void> signUp(String email, String password, String First_Name,
//       String Last_Name, String Phone) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Create a new document in the "users" collection with the user's data
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCredential.user?.uid)
//           .set({
//         'email': email,
//         'First Name': First_Name,
//         'Last Name': Last_Name,
//         'phone': Phone
//       });
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => HomePage()));
//     //  Get.snackbar("Message", "You have been SIgnup");
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         Get.snackbar("Message", e.code);

//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//        // Get.snackbar("Message", e.code);

//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       //Get.snackbar("Message", e.toString());

//       print(e);
//     }
//   }

//   void _submitForm() {
//     String email = _emailController.text;
//     String password = _passController.text;
//     String Fname = _fnameController.text;
//     String phone = _mobilecontroller.text;
//     String lname = _lastnameController.text;

//     signUp(email, password, Fname, phone, lname);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: Scaffold(
//         // resizeToAvoidBottomInset: false,
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Form(
//             key: formGlobalKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 50,
//                   ),
//                   Center(
//                     child: Stack(children: [
//                       _image != null
//                           ? CircleAvatar(
//                               radius: 60,
//                               backgroundImage: MemoryImage(_image!),
//                             )
//                           : CircleAvatar(
//                               backgroundColor: Colors.grey.shade200,
//                               radius: 50,
//                               child: Icon(
//                                 CupertinoIcons.person_alt_circle,
//                                 size: 60,
//                               ),
//                             ),
//                     ]),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   TextFieldInput(
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "Enter your name";
//                       }
//                       return null;
//                     },
//                     //textEditingController: controller.fname,

//                     textEditingController: _fnameController,
//                     hintText: "First Name*",
//                     textInputType: TextInputType.emailAddress,
//                     action: TextInputAction.next,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFieldInput(
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Enter your name";
//                       }
//                       return null;
//                     },
//                     textEditingController: _lastnameController,
//                     hintText: "Last Name*",
//                     textInputType: TextInputType.emailAddress,
//                     action: TextInputAction.next,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFieldInput(
//                     validator: (value) {
//                       if (!RegExp(
//                               r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
//                           .hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     textEditingController: _emailController,
//                     hintText: "Email Address*",
//                     textInputType: TextInputType.emailAddress,
//                     action: TextInputAction.next,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFieldInput(
//                     validator: (value) {
//                       if (value.length < 11) {
//                         return "Enter a valid number";
//                       }
//                       return null;
//                     },
//                     textEditingController: _mobilecontroller,
//                     hintText: "Mobile Number*",
//                     textInputType: TextInputType.number,
//                     action: TextInputAction.next,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFieldInput(
//                     validator: (value) {
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                     textEditingController: _passController,
//                     hintText: "Password",
//                     textInputType: TextInputType.emailAddress,
//                     action: TextInputAction.next,
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _isChecked,
//                         onChanged: _onCheckboxChanged,
//                       ),
//                       Text(
//                         "I accept all terms and conditions ",
//                         style: TextStyle(
//                             fontSize: 13, fontWeight: FontWeight.w400),
//                       ),
//                     ],
//                   ),
//                   MyCustomButton(
//                       title: "Sign Up ",
//                       borderrad: 25,
//                       onaction: () async {
//                         if (formGlobalKey.currentState!.validate()) {
//                           if (_isChecked == true) {
//                             _submitForm();
//                           }
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => HomePage()));
//                         }
//                       },
//                       color1: gd2,
//                       color2: gd1,
//                       width: MediaQuery.of(context).size.width - 40),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





class SignupPage extends StatefulWidget {
  static const idScreen = "signup-up";
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSigningUp = false;
  bool obsCheck1 = false;
  bool obsCheck2 = false;
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  final RegisterViewModel _registerVM = RegisterViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                   Column(
                      children: [
                        Image.asset(
                         "assets/images/logo.png",
                         width: 85,
                         height: 85,
                        ),
                      ],
                    ),
              const Text("Sign up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              const Text("Create an account here", style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 44,),
                  TextFormField(
                    controller: _fNameController,
                    decoration: InputDecoration(
                       prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              right:   BorderSide(width: 1.0, color: Colors.black),
                            ),
                        ),
                        child: const Icon(Icons.person_outline)),
                    ),
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _lNameController,
                    decoration:  InputDecoration(
                      prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              right:   BorderSide(width: 1.0, color: Colors.black),
                            ),
                        ),
                        child: const Icon(Icons.person_outline)),
                    ),
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                       prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              right:   BorderSide(width: 1.0, color: Colors.black),
                            ),
                        ),
                        child: const Icon(Icons.email_outlined)),
                    ),
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      else if(!value.contains("@")){
                        return "enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    inputBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(50), // Set border radius here
                    ),
                    inputDecoration: InputDecoration(
                      hintText: "Phone Number",
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: _phoneController,
                    formatInput: true,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                              border: Border(
                                right:   BorderSide(width: 1.0, color: Colors.black),
                              ),
                          ),
                        child: const Icon(Icons.lock_open_rounded)),
                    ),
                      labelText: 'Password',
                       suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        obsCheck1 =!obsCheck1;
                      });
                    }, icon: Icon( obsCheck1? Icons.visibility_off : Icons.visibility))
                    ),
                    obscureText: obsCheck1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                              border: Border(
                                right:   BorderSide(width: 1.0, color: Colors.black),
                              ),
                          ),
                        child: const Icon(Icons.lock_outline)),
                    ),
                      labelText: 'Confirm Password',
                       suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        obsCheck2 =!obsCheck2;
                      });
                    }, icon: Icon( obsCheck2? Icons.visibility_off : Icons.visibility))
                    ),
                    obscureText: obsCheck2,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: _isSigningUp ? null : () async{
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isSigningUp = true;
                          });
                          // call Firebase function to sign up user
                          bool isRegistered = false;
                           isRegistered = await _registerVM.register(_phoneController.text.trim(),_emailController.text.trim(),
                                _passwordController.text.trim(), _fNameController.text.trim(), _lNameController.text.trim());
                          if (isRegistered) {
                            var userId = FirebaseAuth.instance.currentUser!.uid;
                            await FirebaseFirestore.instance.collection("UsersData").doc(userId).set({"First Name":_fNameController.text.trim(), "Last Name":_lNameController.text.trim(),"Email":_emailController.text.trim()});
                            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => HomePage()),
                                (Route<dynamic> route) => false);
                         }
                        }
                      },
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),
                      ),
                      child: _isSigningUp
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                   TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Already have an account? Login up here'),
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