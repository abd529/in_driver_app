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
              height: 160,
              width: 160,
              image: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed(SignupPage.idScreen);
            },
            style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),), 
             child: const Text("Sign Up",style: TextStyle(color: Colors.white),)),
             const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed(LoginPage.routeName);
            },
            style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),), 
             child: const Text("Sign In",style: TextStyle(color: Colors.white),)),
             const SizedBox(height: 70,),
             ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed(AdminLogin.routeName);
             },
            style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                          shape: RoundedRectangleBorder( //to set border radius to button
                    borderRadius: BorderRadius.circular(50)
                              ),), 
             child: const Text("Log In As Admin",style: TextStyle(color: Colors.white),)), 
                
          ],
        ),
      ),
    );
  }
}
