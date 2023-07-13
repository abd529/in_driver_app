import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

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
              title: const Text('Ride Request'),
              content: const Text('Ride request sent successfully!'),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ride Request'),
              content: const Text('Failed to send ride request. Please try again.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ride Request'),
            content: const Text('Please enter both pickup location and destination.'),
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
    }
  }

  void animateLocation(double lat, double lng)async{
      GoogleMapController controller = await _controllerGoogleMap.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
        target: LatLng(
        lat,lng
        ),
        zoom: 14,
        ),
      ));
      setState(() {}); 
    }

  void _listenForRideRequests() {
    _rideRequestRef = _database.child('liveLocation').child("location");
    _rideRequestRef!.onValue.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Map<dynamic, dynamic>? ridedata =
            event.snapshot.value as Map<dynamic, dynamic>;
        print("${ridedata["Latitude"]},${ridedata["Longitude"]}");
        animateLocation(ridedata["Latitude"],ridedata["Longitude"]);
       
      }
    });
  }
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                _controllerGoogleMap.complete(controller);
              },
            ),
        ],
      ),
    );
  }
}
