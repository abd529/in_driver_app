import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final _database = FirebaseDatabase.instance.reference();
  List<dynamic> _rideRequests = [];

  @override
  void initState() {
    super.initState();
    _listenForRideRequests();
  }

  @override
  void dispose() {
    _database.child('rideRequests').onChildAdded.listen((event) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Screen'),
        actions: [
          IconButton(onPressed: (){
            _listenForRideRequests();
          }, icon: const Icon(Icons.refresh)),

        ],
      ),
      body: ListView.builder(
        itemCount: _rideRequests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_rideRequests[index]["pickupLocation"]),
            subtitle: Text(_rideRequests[index]['destination']),
            trailing: ElevatedButton(
              onPressed: () {
                _acceptRideRequest(index);
              },
              child: const Text('Accept'),
            ),
          );
        },
      ),
    );
  }

  void _listenForRideRequests() {
    _database.child('rideRequests').onValue.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Map<dynamic, dynamic> rideRequestData =
            event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          print(rideRequestData);
          List newList = rideRequestData.values.toList();
          _rideRequests = newList;
          print(_rideRequests);
        });
      }
    });
  }

  void _acceptRideRequest(int index) {
    // Perform actions to accept the ride request
    // For example, you can update the ride request status in the database
    String rideRequestId = _rideRequests[index]["rideRequestId"];
    DatabaseReference nodeRef = _database.child('rideRequests').child(rideRequestId) ;
    nodeRef
        .update({"status":"accepted"})
        .then((value) {
      // Ride request accepted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ride Request'),
            content: const Text('You have accepted the ride request.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Error occurred while accepting the ride request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ride Request'),
            content:
                const Text('Failed to accept the ride request. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
