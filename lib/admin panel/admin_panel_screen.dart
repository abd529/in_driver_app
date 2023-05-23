import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/admin%20panel/add_user.dart';
import 'package:in_driver_app/models/usermodel.dart';

class AdminPanelScreen extends StatefulWidget {
  static const routName = "admin-panel";
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {

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

  Widget _buildListItem(UserModel user) {
    return Dismissible(
      key: Key(user.id as String),
      onDismissed: (direction) {
        _deleteTask(user);
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text(user.fname),
        trailing: IconButton(onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm!'),
                  content: const Text('Do you want to delete this user?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(onPressed: (){
                      _deleteTask(user);
                      Navigator.of(context).pop();
                    }, child: const Text("Delete", style: TextStyle(color: Colors.red),))
                  ],
                );
              },
            );
        }, icon: const Icon(Icons.delete)),
      ),
    );
  }

    void _deleteTask(UserModel task) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(task.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        print("hey hey");
        Navigator.of(context).pushNamed(AddUser.routeName);
      }, child: const Icon(Icons.person_add),),
      body: SafeArea(child:
      SizedBox(
        width: double.infinity,
        child:  Column(
         children: [ 
          const Text("All Users", style: TextStyle(fontSize: 18),),
           StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("users").snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              return Expanded(child: _buildList(snapshot.data));
            })),
            ElevatedButton(onPressed: (){}, child: Text("heh"))
          
          ]
        ),
      )),
    );
  }
}