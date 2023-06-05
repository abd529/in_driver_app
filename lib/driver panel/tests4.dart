import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final DatabaseReference _rideRequestRef =
      FirebaseDatabase.instance.reference().child('ride_requests');

  @override
  void initState() {
    super.initState();
    _rideRequestRef.onChildAdded.listen((event) {
      // Listen for new ride requests
      String requestId = event.snapshot.key!;
      Map<String, dynamic> rideData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      showRideRequestDialog(requestId, rideData);
    });
  }

  void showRideRequestDialog(String requestId, Map<String, dynamic> rideData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Ride Request'),
          content: Text(
              'Pickup: ${rideData['pickup_location']}\nDropoff: ${rideData['dropoff_location']}'),
          actions: [
            TextButton(
              onPressed: () {
                acceptRideRequest(requestId);
                Navigator.pop(context);
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                rejectRideRequest(requestId);
                Navigator.pop(context);
              },
              child: Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void acceptRideRequest(String requestId) {
    // Update ride request status to accepted in the database
    _rideRequestRef
        .child(requestId)
        .update({'status': 'accepted'}).then((value) {
      // Handle success
      print('Ride request accepted!');
    }).catchError((error) {
      // Handle error
      print('Error accepting ride request: $error');
    });
  }

  void rejectRideRequest(String requestId) {
    // Update ride request status to rejected in the database
    _rideRequestRef
        .child(requestId)
        .update({'status': 'rejected'}).then((value) {
      // Handle success
      print('Ride request rejected!');
    }).catchError((error) {
      // Handle error
      print('Error rejecting ride request: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver App'),
      ),
      body: Center(
        child: Text('Waiting for ride requests...'),
      ),
    );
  }
}
