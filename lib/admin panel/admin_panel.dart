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

class Tab1Widget extends StatefulWidget {
  const Tab1Widget({super.key});

  @override
  State<Tab1Widget> createState() => _Tab1WidgetState();
}

class _Tab1WidgetState extends State<Tab1Widget> {
  List<String> customers =[];
  List<UserModel> users =[];
  List<String> searchResults = [];
  int heightCheck = 0;
  TextEditingController controller = TextEditingController();
  void search(String query) {
    setState(() {
      heightCheck = 250;
      searchResults = customers
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
     if(controller.text.isEmpty){searchResults = [];}
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget _buildListItem(UserModel user) {
    return Card(
      child: ListTile(
        title: Text(user.fname),
        
      ),
    );
  }
    Widget _buildList(QuerySnapshot<Object?>? snapshot) {
    if (snapshot!.docs.isEmpty) {
      return const Center(child: Text("No Users !"));
    } else {
      List customer =[];
      customers = [];
      snapshot.docs.forEach((doc) { 
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data!['Role']  == 'Customer') {
      customer.add(doc);
      customers.add(data["First Name"]);
    }
      });
      print("riderrrrrrrzzzz: $customers");
      return ListView.builder(
        itemCount: customer.length,
        itemBuilder: (context, index) {
          final doc = customer[index];
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              onChanged: (value) => search(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: searchResults.isEmpty? 0: heightCheck.toDouble(),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: (){
                    setState(() {
                      searchResults = [];
                      heightCheck = 0;
                    });
                  },
                );
              },
            ),
          ),
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

class Tab2Widget extends StatefulWidget {
  @override
  State<Tab2Widget> createState() => _Tab2WidgetState();
}

class _Tab2WidgetState extends State<Tab2Widget> {
  List<String> riders =[];
  List<String> searchResults = [];
  int heightCheck = 0;
  TextEditingController controller = TextEditingController();
  void search(String query) {
    setState(() {
      heightCheck = 250;
      searchResults = riders
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
     if(controller.text.isEmpty){searchResults = [];}
    });
  }

  Widget build(BuildContext context) {
    
    Widget _buildListItem(UserModel user) {
    return Card(
      child: ListTile(
        title: Text(user.fname),
        
      ),
    );
  }

    Widget _buildList(QuerySnapshot<Object?>? snapshot) {
    if (snapshot!.docs.isEmpty) {
      return const Center(child: Text("No Users !"));
    } else {
      List customer =[];
      riders = [];
      snapshot.docs.forEach((doc) { 
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data!['Role']  == 'Rider') {
      customer.add(doc);
      riders.add(data["First Name"]);
    }
      });
      print("riderrrrrrrzzzz: $riders");
      return ListView.builder(
        itemCount: customer.length,
        itemBuilder: (context, index) {
          final doc = customer[index];
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
          const Text("Drivers/Riders", style: TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              onChanged: (value) => search(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: searchResults.isEmpty? 0: heightCheck.toDouble(),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: (){
                    setState(() {
                      searchResults = [];
                      heightCheck = 0;
                    });
                  },
                );
              },
            ),
          ),
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

class Tab3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'All Rides',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}