import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyTestMap extends StatefulWidget {
  const MyTestMap({super.key});

  @override
  State<MyTestMap> createState() => _MyTestMapState();
}

class _MyTestMapState extends State<MyTestMap> {
  @override
  void initState() {
    _listenForRideRequests();
    super.initState();
  }

  final _database = FirebaseDatabase.instance.reference();
  DatabaseReference? _rideRequestRef;
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  TextEditingController fareController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  void _requestRide() {
    String pickupLocation = pickUpController.text;
    String destination = dropOffController.text;
    String id = userId;
    String status = "pending";
    if (pickupLocation.isNotEmpty && destination.isNotEmpty) {
      // Store ride request details in Firebase Realtime Database
      _database.child('rideRequests').child(id).set({
        'pickupLocation': pickupLocation,
        'destination': destination,
        'rideRequestId': id,
        'status': status
      }).then((value) {
        // Success, ride request details are stored
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ride Request'),
              content: Text('Ride request sent successfully!'),
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
        // Error occurred while storing ride request details
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ride Request'),
              content: Text('Failed to send ride request. Please try again.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ride Request'),
            content: Text('Please enter both pickup location and destination.'),
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
    }
  }

  void _listenForRideRequests() {
    _rideRequestRef = _database.child('liveLocation').child("location");
    _rideRequestRef!.onValue.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Object? rideRequestData = event.snapshot.value;
        Map<dynamic, dynamic>? ridedata =
            event.snapshot.value as Map<dynamic, dynamic>;
        print(ridedata);
        // Perform necessary actions based on the updated ride request details
        // For example, you can update the UI or trigger notifications
        // print(' $rideRequestData');
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Ride Request'),
        //       content: Text('New ride request: $rideRequestData'),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        //);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
