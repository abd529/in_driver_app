import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final _database = FirebaseDatabase.instance.reference();
  List<Map<dynamic, dynamic>> _rideRequests = [];

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
        title: Text('Driver Screen'),
      ),
      body: ListView.builder(
        itemCount: _rideRequests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_rideRequests[index]['pickupLocation']),
            subtitle: Text(_rideRequests[index]['destination']),
            trailing: ElevatedButton(
              onPressed: () {
                _acceptRideRequest(index);
              },
              child: Text('Accept'),
            ),
          );
        },
      ),
    );
  }

  void _listenForRideRequests() {
    _database.child('rideRequests').onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Map<dynamic, dynamic> rideRequestData =
            event.snapshot.value as Map<dynamic, dynamic>;

        // Perform necessary actions based on the ride request details
        // For example, you can update the UI or trigger notifications
        setState(() {
          _rideRequests.add(rideRequestData);
        });
      }
    });
  }

  void _acceptRideRequest(int index) {
    // Perform actions to accept the ride request
    // For example, you can update the ride request status in the database
    String rideRequestId = _rideRequests[index]['rideRequestId'];
    _database
        .child('rideRequests/$rideRequestId/status')
        .set('accepted')
        .then((value) {
      // Ride request accepted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ride Request'),
            content: Text('You have accepted the ride request.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
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
            title: Text('Ride Request'),
            content:
                Text('Failed to accept the ride request. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
