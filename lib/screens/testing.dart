// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// import 'package:in_driver_app/screens/home.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// import '../auth/login.dart';
// import '../models/registerviewmodel.dart';

// class Signup extends StatefulWidget {
//   static const idScreen = "signup-up";
//   @override
//   _SignupState createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _fNameController = TextEditingController();
//   final _lNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isSigningUp = false;
//   bool obsCheck1 = false;
//   bool obsCheck2 = false;
//   PhoneNumber number = PhoneNumber(isoCode: 'PK');
//   final RegisterViewModel _registerVM = RegisterViewModel();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                    Column(
//                       children: [
//                         Image.asset(
//                          "assets/images/logo.png",
//                          width: 85,
//                          height: 85,
//                         ),
//                       ],
//                     ),
//               const Text("Sign up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
//               const SizedBox(height: 10,),
//               const Text("Create an account here", style: TextStyle(color: Colors.grey),),
//               const SizedBox(height: 44,),
//                   TextFormField(
//                     controller: _fNameController,
//                     decoration: InputDecoration(
//                        prefixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                             border: Border(
//                               right:   BorderSide(width: 1.0, color: Colors.black),
//                             ),
//                         ),
//                         child: const Icon(Icons.person_outline)),
//                     ),
//                       labelText: 'First Name',
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your first name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _lNameController,
//                     decoration:  InputDecoration(
//                       prefixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                             border: Border(
//                               right:   BorderSide(width: 1.0, color: Colors.black),
//                             ),
//                         ),
//                         child: const Icon(Icons.person_outline)),
//                     ),
//                       labelText: 'Last Name',
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your last name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                        prefixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                             border: Border(
//                               right:   BorderSide(width: 1.0, color: Colors.black),
//                             ),
//                         ),
//                         child: const Icon(Icons.email_outlined)),
//                     ),
//                       labelText: 'Email Address',
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       else if(!value.contains("@")){
//                         return "enter a valid email";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10,),
                  
//                   InternationalPhoneNumberInput(
//                     onInputChanged: (PhoneNumber number) {
//                       print(number.phoneNumber);
//                     },
//                     onInputValidated: (bool value) {
//                       print(value);
//                     },
//                     selectorConfig: SelectorConfig(
//                       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                     ),
//                     inputBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.transparent),

//                       borderRadius:
//                           BorderRadius.circular(50), // Set border radius here
//                     ),
//                     inputDecoration: InputDecoration(
//                       hintText: "Phone Number",
//                     ),
//                     ignoreBlank: false,
//                     autoValidateMode: AutovalidateMode.disabled,
//                     selectorTextStyle: TextStyle(color: Colors.black),
//                     initialValue: number,
//                     textFieldController: _phoneController,
//                     formatInput: true,
//                     keyboardType: TextInputType.numberWithOptions(
//                         signed: true, decimal: true),
//                     onSaved: (PhoneNumber number) {
//                       print('On Saved: $number');
//                     },
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       prefixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                               border: Border(
//                                 right:   BorderSide(width: 1.0, color: Colors.black),
//                               ),
//                           ),
//                         child: const Icon(Icons.lock_open_rounded)),
//                     ),
//                       labelText: 'Password',
//                        suffixIcon: IconButton(onPressed: (){
//                       setState(() {
//                         obsCheck1 =!obsCheck1;
//                       });
//                     }, icon: Icon( obsCheck1? Icons.visibility_off : Icons.visibility))
//                     ),
//                     obscureText: obsCheck1,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     decoration: InputDecoration(
//                       prefixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 5),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                               border: Border(
//                                 right:   BorderSide(width: 1.0, color: Colors.black),
//                               ),
//                           ),
//                         child: const Icon(Icons.lock_outline)),
//                     ),
//                       labelText: 'Confirm Password',
//                        suffixIcon: IconButton(onPressed: (){
//                       setState(() {
//                         obsCheck2 =!obsCheck2;
//                       });
//                     }, icon: Icon( obsCheck2? Icons.visibility_off : Icons.visibility))
//                     ),
//                     obscureText: obsCheck2,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: ElevatedButton(
//                       onPressed: _isSigningUp ? null : () async{
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isSigningUp = true;
//                           });
//                           // call Firebase function to sign up user
//                           bool isRegistered = false;
//                            isRegistered = await _registerVM.register(_phoneController.text.trim(),_emailController.text.trim(),
//                                 _passwordController.text.trim(), _fNameController.text.trim(), _lNameController.text.trim());
//                           if (isRegistered) {
//                             var userId = FirebaseAuth.instance.currentUser!.uid;
//                             await FirebaseFirestore.instance.collection("UsersData").doc(userId).set({"First Name":_fNameController.text.trim(), "Last Name":_lNameController.text.trim(),"Email":_emailController.text.trim()});
//                             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => HomePage()),
//                                 (Route<dynamic> route) => false);
//                          }
//                         }
//                       },
//                        style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
//                           shape: RoundedRectangleBorder( //to set border radius to button
//                     borderRadius: BorderRadius.circular(50)
//                               ),
//                       ),
//                       child: _isSigningUp
//                         ? const CircularProgressIndicator()
//                         : const Text('Sign Up',style: TextStyle(color: Colors.white),),
//                     ),
//                   ),
//                    TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage()),
//                     );
//                   },
//                   child: const Text('Already have an account? Login up here'),
//                 ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }