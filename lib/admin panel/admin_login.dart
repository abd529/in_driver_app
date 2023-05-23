import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/loginviewmodel.dart';
import '../screens/admin_panel_screen.dart';

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
                        SvgPicture.asset(
                         "assets/images/logo.svg",
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
                             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => const AdminPanelScreen()),(Route<dynamic> route) => false);
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
                        : const Text('Sign In'),  
                    ),
                  ),
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