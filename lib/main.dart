import 'package:flutter/material.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/auth/auth_verifiy.dart';
import 'package:in_driver_app/auth/forgot.dart';
import 'package:in_driver_app/auth/login.dart';
import 'package:in_driver_app/auth/signup.dart';
import 'package:in_driver_app/screens/bottom_menu_bar.dart';
import 'package:in_driver_app/screens/home.dart';
import 'package:in_driver_app/screens/profileview.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const BottomMenu()
          : const LoginPage(),
      initialRoute: LoginPage.idScreen,
      routes: {
        AuthHome.idScreen: (context) => const AuthHome(),
        SignupPage.idScreen: (context) => const SignupPage(),
        LoginPage.idScreen: (context) => const LoginPage(),
        HomePage.idScreen: (context) => const HomePage(),
        ForgitPassword.idScreen: (context) => const ForgitPassword(),
        EmailVerification.idScreen: (context) => const EmailVerification(),
      },
    );
  }
}
