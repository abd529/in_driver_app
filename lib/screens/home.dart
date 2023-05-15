import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String idScreen = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("Hoem"))],
      ),
    );
  }
}
