// ignore_for_file: depend_on_referenced_packages, unused_local_variable, prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/auth/auth_verifiy.dart';
import 'package:in_driver_app/auth/forgot.dart';
import 'package:in_driver_app/firebase_options.dart';
import 'package:in_driver_app/screens/home.dart';
import 'package:in_driver_app/screens/live_location.dart';
import 'package:in_driver_app/screens/ratingscreen.dart';
import 'package:in_driver_app/screens/searchscreen.dart';
import 'package:in_driver_app/screens/splash_screen.dart';
import 'package:in_driver_app/widgets/materialColor.dart';
import 'admin panel/admin_login.dart';
import 'admin panel/admin_panel_screen.dart';
import 'admin panel/admin_panel.dart';
import 'driver panel/driver_live_location.dart';
import 'providers/appDataprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  Map message = event.toMap();
  print('backgroundMessage: message => ${message.toString()}');
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: message["notification"]["title"],
          body: message["notification"]["body"],
          wakeUpScreen: true,
          fullScreenIntent: true),
      actionButtons: [
        NotificationActionButton(
          label: 'Accept',
          enabled: true,
          actionType: ActionType.Default,
          key: 'accept',
        ),
        NotificationActionButton(
          label: 'Reject',
          enabled: true,
          actionType: ActionType.Default,
          key: 'reject',
        ),
      ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
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
          fontFamily: GoogleFonts.poppins().fontFamily,
          primaryColor: const Color.fromRGBO(64, 190, 148, 1),
          primarySwatch:
              generateMaterialColor(const Color.fromRGBO(64, 190, 148, 1)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(64, 190, 148, 1),
          )),
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? FirebaseAuth.instance.currentUser!.uid ==
                    "ZUTdZDhTTBXhQqnTXHQsqZdtJJH3"
                ? AdminPanel()
                : HomePage()
            : SplashScreen(),
        routes: {
          AuthHome.idScreen: (context) => const AuthHome(),
          // SignupPage.idScreen: (context) => SignupPage(),
          // LoginPage.routeName: (context) => LoginPage(),
          HomePage.idScreen: (context) => HomePage(),
          ForgitPassword.idScreen: (context) => const ForgitPassword(),
          EmailVerification.idScreen: (context) => const EmailVerification(),
          SearchScreen.idScreen: (context) => const SearchScreen(),
          AdminPanelScreen.routName: (ctx) => const AdminPanelScreen(),
          AdminLogin.routeName: (ctx) => const AdminLogin(),
          RatingScreen.routeName: (ctx) => RatingScreen()
        },
      ),
    );
  }
}
