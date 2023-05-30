// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:in_driver_app/admin%20panel/tabs_screen.dart';

import '../models/loginviewmodel.dart';

class AdminLogin extends StatefulWidget {
  static const routeName = "admin-login";
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool obsCheck = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  final LoginViewModel _loginVM = LoginViewModel();
  String errMsg = '';

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
              const Text("Welcome Back Admin", style: TextStyle(color: Colors.grey),),
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
                          child: const Icon(Icons.lock_open_rounded)),
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
                           if(isLoggedIn && _emailController.text == "admin@gmail.com" && _passwordController.text == "admin123"){
                             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => AdminPanel()),(Route<dynamic> route) => false);
                           }else{
                            setState(() {
                            errMsg = "Invalid Credienticals";
                            _isLoggingIn = false;  
                            });
                            
                           }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),
                      ),
                      child: _isLoggingIn
                        ? const CircularProgressIndicator()
                        : const Text('Sign In', style: TextStyle(color: Colors.white),),  
                    ),
                  ),
                  Text(errMsg,style: const TextStyle(color: Colors.red),),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}