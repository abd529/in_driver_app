import 'package:flutter/material.dart';
import 'package:in_driver_app/admin%20panel/admin_login.dart';
import '../widgets/myColors.dart';
import '../widgets/mybutton.dart';
import 'login.dart';
import 'signup.dart';

class AuthHome extends StatefulWidget {
  static const String idScreen = 'authhome';

  const AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              fit: BoxFit.cover,
              height: 60,
              width: 60,
              image: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(height: 50,),
            MyCustomButton(
                width: MediaQuery.of(context).size.width - 70,
                title: "Sign Up",
                borderrad: 25,
                onaction: () {
                  Navigator.pushNamed(context, SignupPage.idScreen);
                },
                color1: gd2,
                color2: gd1),
            const SizedBox(
              height: 20,
            ),
            MyCustomButton(
                width: MediaQuery.of(context).size.width - 70,
                title: "Sign In",
                borderrad: 25,
                onaction: () {
                  Navigator.pushNamed(context, LoginPage.idScreen);
                },
                color1: green,
                color2: green),
                SizedBox(height: 50,),
            MyCustomButton(
                width: MediaQuery.of(context).size.width - 70,
                title: "Log in as Admin",
                borderrad: 25,
                onaction: () {
                  Navigator.pushNamed(context, AdminLogin.routeName);
                },
                color1: green,
                color2: green),    
          ],
        ),
      ),
    );
  }
}
