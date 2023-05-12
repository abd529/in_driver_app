import 'package:flutter/material.dart';
import '../widgets/myColors.dart';
import '../widgets/mybutton.dart';
import 'login.dart';
import 'signup.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            fit: BoxFit.cover,
            height: 400,
            width: 400,
            image: AssetImage('assets/logo.png'),
          ),
          MyCustomButton(
              width: MediaQuery.of(context).size.width - 70,
              title: "Sign Up",
              borderrad: 25,
              onaction: () {},
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
                //   Get.to(() => LoginPage());
              },
              color1: green,
              color2: green),
        ],
      ),
    );
  }
}
