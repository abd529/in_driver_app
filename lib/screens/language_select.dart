// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LanguageSel extends StatefulWidget {
  const LanguageSel({super.key});

  @override
  State<LanguageSel> createState() => _LanguageSelState();
}

class _LanguageSelState extends State<LanguageSel> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          CupertinoIcons.left_chevron,
          color: Theme.of(context).primaryColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageIcon(
              AssetImage("assets/images/menuicon.png"),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Languages",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ListTile(
            title: Text('français'),
            trailing: Radio<String>(
              value: 'Option 2',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('English'),
            trailing: Radio<String>(
              value: 'Option 1',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}