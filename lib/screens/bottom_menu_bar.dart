// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:in_driver_app/screens/home.dart';
import 'package:in_driver_app/screens/profileview.dart';

class BottomMenu extends StatefulWidget {
  static const String idScreen = 'bottombar';
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int pgindex = 0;
  void selindex(int index) {
    setState(() {});
    pgindex = index;
  }

  final List<Widget> pages = [
    HomePage(),
    ProfileView(),
  ];
  List<int> listofpages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedFontSize: 14,
            selectedItemColor: Colors.black,
            selectedFontSize: 16,
            selectedLabelStyle: TextStyle(color: Colors.black),
            iconSize: 30,
            onTap: selindex,
            currentIndex: pgindex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: Colors.grey,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  label: "Profile"),
            ]),
        body: pages[pgindex]);
  }
}
