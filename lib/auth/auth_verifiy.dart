import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/home.dart';

class EmailVerification extends StatefulWidget {
  static const String idScreen = 'verification';

  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool verify = false;
  Timer? time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!verify) {
      sendVerificationEmail();
      time = Timer.periodic(Duration(seconds: 3), (_) => EmailVerifyStatus());
    }
  }

  @override
  void dispose() {
    time?.cancel();
  }

  Future EmailVerifyStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      verify = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (verify) {
      time?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return verify
        ? HomePage()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your email has been sent to your email account"),
                ElevatedButton.icon(
                  onPressed: sendVerificationEmail,
                  icon: Icon(Icons.send),
                  label: Text("Resend"),
                )
              ],
            ),
          );
  }
}
