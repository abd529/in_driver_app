// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_driver_app/auth/signup.dart';
import 'package:get/get.dart';
import 'package:in_driver_app/screens/home.dart';

import '../Models/loginviewmodel.dart';
import '../widgets/myColors.dart';
import '../widgets/myTextField.dart';
import '../widgets/mybutton.dart';
import 'forgot.dart';

// class LoginPage extends StatefulWidget {
//   static const String idScreen = 'login';

//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   LoginViewModel loginVM = LoginViewModel();
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _passController = TextEditingController();

//   bool _isChecked = false;
//   String _textFieldValue = '';
// //function to handle checkbox
//   void _handleCheckboxChanged(bool? checkboxState) {
//     setState(() {
//       _isChecked = checkboxState ?? true;
//     });
//   }

// //function to store value in database
//   void _handleTextFieldChanged(String value) {
//     setState(() {
//       _textFieldValue = value;
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
//     super.dispose();
//   }

//   final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

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
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: appbar,
//           leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Icon(
//               CupertinoIcons.left_chevron,
//               color: Colors.black,
//               size: 30,
//             ),
//           ),
//           title: Text(
//             "Sign In ",
//             style: TextStyle(fontSize: 26, color: appbartitle),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Form(
//             key: formGlobalKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 120,
//                 ),
//                 TextFieldInput(
//                     validator: (value) {
//                       if (!RegExp(
//                               r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
//                           .hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     onChanged: _handleTextFieldChanged,
//                     action: TextInputAction.next,
//                     textEditingController: _emailController,
//                     hintText: "Email",
//                     textInputType: TextInputType.emailAddress),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 TextFieldInput(
//                     validator: (value) {
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                     onChanged: _handleTextFieldChanged,
//                     action: TextInputAction.next,
//                     textEditingController: _passController,
//                     hintText: "Password",
//                     textInputType: TextInputType.emailAddress),

//                 SizedBox(
//                   height: 30,
//                 ),
//                 //remember me sec
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _isChecked,
//                           onChanged: _handleCheckboxChanged,
//                         ),
//                         Text(
//                           "Remember Me ",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, ForgitPassword.idScreen);
//                       },
//                       child: Text(
//                         "Forgot Password?",
//                         style: TextStyle(
//                             color: Colors.deepPurple,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),

//                 MyCustomButton(
//                     title: "Sign In ",
//                     borderrad: 25,
//                     onaction: () async {
//                       if (formGlobalKey.currentState!.validate()) {
//                         bool loggedIn = false;
//                         try {
//                           UserCredential userCredential = await FirebaseAuth
//                               .instance
//                               .signInWithEmailAndPassword(
//                             email: _emailController.text.trim(),
//                             password: _passController.text.trim(),
//                           );
//                           Navigator.of(context).pushNamed(HomePage.idScreen);
//                          // Get.snackbar("Message", "You have been logged in");
//                           // User is signed in
//                         } on FirebaseAuthException catch (e) {
//                           if (e.code == 'user-not-found') {
//                             Get.snackbar("Message", e.code);
//                             print('No user found for that email.');
//                           } else if (e.code == 'wrong-password') {
//                             Get.snackbar("Message", e.code);
//                             print('Wrong password provided for that user.');
//                           }
//                         }

//                         // loggedIn =
//                         // await loginVM.login(
//                         //     controller.email.text.trim(),
//                         //     controller.pass.text.trim());
//                         // if (loggedIn) {
//                         print("ok");

//                         //   _showetoast("Sigin Successfully");
//                         // } else {
//                         //   _showetoast(loginVM.message);
//                         // }
//                       } else
//                         _showetoast("Please enter valid pass or email");
//                     },
//                     color1: gd2,
//                     color2: gd1,
//                     width: MediaQuery.of(context).size.width - 40),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Text("Or"),
//                     ),
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 60),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an Accound?",
//                         style: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, SignupPage.idScreen);
//                         },
//                         child: Text(
//                           "Create new one",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  static const routeName = "login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obsCheck = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;
    final LoginViewModel _loginVM = LoginViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              const Text("Sign in", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              const Text("Welcome Back", style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 44,),
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: _passwordController,
                    decoration:  InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          decoration: const BoxDecoration(
                                border: Border(
                                  right:   BorderSide(width: 1.0, color: Colors.black),
                                ),
                            ),
                          child: Icon(Icons.lock_open_rounded)),
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          obsCheck =!obsCheck;
                        });
                      }, icon: Icon( obsCheck? Icons.visibility : Icons.visibility_off))
                    ),
                    obscureText: !obsCheck,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(child: Text("Forgot Password?"),onPressed: (){
                      Navigator.of(context).pushNamed(ForgitPassword.idScreen);
                    }, )),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: _isLoggingIn ? null : () async{
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoggingIn = true;
                          });
                           bool isLoggedIn = await _loginVM.login(_emailController.text, _passwordController.text);
                           if(isLoggedIn){
                             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => HomePage()),(Route<dynamic> route) => false);
                           }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),
                      ),
                      child: _isLoggingIn
                        ? const CircularProgressIndicator()
                        : const Text('Sign In',style: TextStyle(color: Colors.white),),  
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text('Don\'t have an account? Sign up here'),
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