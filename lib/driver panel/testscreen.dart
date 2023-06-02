import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  late GoogleMapController mapController;
  late DatabaseReference _rideRequestRef;
  String userId = 'user_id'; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      // Initialize Firebase
      _rideRequestRef = FirebaseDatabase.instance.ref().child('ride_requests');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Request'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Set initial map position
              zoom: 12.0,
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                sendRideRequest();
              },
              child: Text('Request Ride'),
            ),
          ),
        ],
      ),
    );
  }

  void sendRideRequest() {
    // Get user's current location
    // You can use any method to get the location, such as the geolocator package
    LatLng userLocation = getCurrentLocation();

    // Save the ride request in Firebase
    _rideRequestRef.child(userId).set({
      'latitude': userLocation.latitude,
      'longitude': userLocation.longitude,
    }).then((value) {
      // Handle success
      print('Ride request sent!');
    }).catchError((error) {
      // Handle error
      print('Error sending ride request: $error');
    });
  }

  LatLng getCurrentLocation() {
    // Implement your logic to get the user's current location here
    // You can use the geolocator package or any other location service
    // For simplicity, let's return a static location for now
    return LatLng(37.7749, -122.4194); // San Francisco coordinates
  }
}
