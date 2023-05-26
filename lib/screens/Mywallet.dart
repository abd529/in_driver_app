// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/myColors.dart';
import 'language_select.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Replace with your actual item count
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 200, // Adjust the width of the card as needed
              margin: EdgeInsets.all(8), // Adjust the margin as needed
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add your desired card content
                    Container(
                      height: 50,
                      color: IconColor,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Card $index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Add additional card content if needed
                  ],
                ),
              ),
            );
          },
        ));
  }
}
