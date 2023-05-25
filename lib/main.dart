import 'package:flutter/material.dart';
import 'package:in_driver_app/admin%20panel/add_user.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/auth/auth_verifiy.dart';
import 'package:in_driver_app/auth/forgot.dart';
import 'package:in_driver_app/auth/login.dart';
import 'package:in_driver_app/auth/signup.dart';
import 'package:in_driver_app/screens/admin_panel_screen.dart';
import 'package:in_driver_app/screens/home.dart';
import 'package:in_driver_app/screens/searchscreen.dart';
import 'package:in_driver_app/widgets/materialColor.dart';
import 'admin panel/admin_login.dart';
import 'providers/appDataprovider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(64, 190, 148, 1),
          primarySwatch: generateMaterialColor(const Color.fromRGBO(64, 190, 148, 1)),
          elevatedButtonTheme: ElevatedButtonThemeData(
           style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(64, 190, 148, 1),
          )
        ),),
        home: FirebaseAuth.instance.currentUser != null
            ? HomePage()
            : const AuthHome(),
        routes: {
          AuthHome.idScreen: (context) => const AuthHome(),
          SignupPage.idScreen: (context) => const SignupPage(),
          LoginPage.idScreen: (context) => const LoginPage(),
          HomePage.idScreen: (context) => HomePage(),
          ForgitPassword.idScreen: (context) => const ForgitPassword(),
          EmailVerification.idScreen: (context) => const EmailVerification(),
          SearchScreen.idScreen: (context) => const SearchScreen(),
          AdminPanelScreen.routName : (ctx) => const AdminPanelScreen(),
          AdminLogin.routeName : (ctx) => const AdminLogin(),
          AddUser.routeName : (ctx) => const AddUser(),
        },
      ),
    );
  }
}
