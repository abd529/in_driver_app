import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_home.dart';
import '../models/usermodel.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  logOut(){
  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Do you want to log out?'),
                  actions: [
                    TextButton(
                      child: const Text('Log Out'),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(AuthHome.idScreen,(boolo){return false;});
                      },
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: const Text("Cancel", style: TextStyle(color: Colors.red),))
                  ],
                );
              },
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){logOut();}, child: const Icon(Icons.logout, color: Colors.white,)),
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1Widget(),
          Tab2Widget(),
          Tab3Widget(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.people),text: "Customers",),
          Tab(icon: Icon(Icons.person_4_sharp), text: "Drivers",),
          Tab(icon: Icon(Icons.car_repair), text: "Rides"),
        ],
      ),
    );
  }
}

class Tab1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _buildListItem(UserModel user) {
    return ListTile(
      title: Text(user.fname),
      
    );
  }

    Widget _buildList(QuerySnapshot<Object?>? snapshot) {
    if (snapshot!.docs.isEmpty) {
      return const Center(child: Text("No Users !"));
    } else {
      return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          final user = UserModel.fromSnapshot(doc);
          return _buildListItem(user);
        },
      );
    }
  }
  
    return SafeArea(child:
      SizedBox(
        width: double.infinity,
        child:  Column(
         children: [ 
          const Text("Customers", style: TextStyle(fontSize: 18),),
           StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("UsersData").snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return Expanded(child: _buildList(snapshot.data));
            })),
          ]
        ),
      ));
  }
}

class Tab2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tab 2',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class Tab3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tab 3',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}