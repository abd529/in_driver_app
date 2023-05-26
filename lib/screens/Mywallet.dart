// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/screens/paymentmethod.dart';

import '../widgets/myColors.dart';
import 'language_select.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageIcon(
                AssetImage("assets/images/menu.png"),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "My Wallet",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 190,
                        width: 300,
                        decoration: BoxDecoration(
                          color: IconColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        bottom: 10,
                        child: Container(
                          height: 230,
                          width: 300,
                          decoration: BoxDecoration(
                            color: IconColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        bottom: 0,
                        child: Container(
                          height: 230,
                          width: 300,
                          decoration: BoxDecoration(
                            color: IconColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/cardlogo.png')),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cash",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text("Default Payment Method",
                                          style: TextStyle(fontSize: 16))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 1.5,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Balance"),
                                        Text("\$250")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Balance"),
                                        Text("\$250")
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SelectTile(
                  title: "Payment Methods",
                  action:  ()=>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethod()))
                  
                ),
                SizedBox(
                  height: 10,
                ),
                SelectTile(
                  title: "Coupon",
                  action: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                SelectTile(
                  title: "Transactions History",
                  action: () {},
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Container(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class SelectTile extends StatelessWidget {
  final String title;
  final VoidCallback action;
  const SelectTile({
    super.key,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: IconColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            IconButton(
              onPressed:
                action,
              
              icon: Icon(
                CupertinoIcons.right_chevron,
              ),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
