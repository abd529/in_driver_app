import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  late GoogleMapController mapController;
  late DatabaseReference _rideRequestRef;
  String driverId = 'driver_id'; // Replace with the actual driver ID
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      // Initialize Firebase
      _rideRequestRef =
          FirebaseDatabase.instance.reference().child('ride_requests');
      _rideRequestRef.onChildAdded.listen((event) {
        // Listen for new ride requests
        String requestId = event.snapshot.key!;
        Map<String, dynamic> rideData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        showRideRequestDialog(requestId, rideData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver App'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        polylines: _polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Set initial map position
          zoom: 12.0,
        ),
      ),
    );
  }

  void showRideRequestDialog(String requestId, Map<String, dynamic> rideData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Ride Request'),
          content: Text('User ID: ${rideData['user_id']}'),
          actions: [
            TextButton(
              onPressed: () {
                acceptRideRequest(requestId, rideData);
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

  void acceptRideRequest(String requestId, Map<String, dynamic> rideData) {
    // Update ride request status to accepted in Firebase
    _rideRequestRef.child(requestId).update({
      'status': 'accepted',
      'driver_id': driverId,
    }).then((value) {
      // Handle success
      print('Ride request accepted!');
      drawRoute(rideData['user_location'], rideData['driver_location']);
    }).catchError((error) {
      // Handle error
      print('Error accepting ride request: $error');
    });
  }

  void rejectRideRequest(String requestId) {
    // Update ride request status to rejected in Firebase
    _rideRequestRef.child(requestId).update({
      'status': 'rejected',
      'driver_id': driverId,
    }).then((value) {
      // Handle success
      print('Ride request rejected!');
    }).catchError((error) {
      // Handle error
      print('Error rejecting ride request: $error');
    });
  }

  void drawRoute(
      Map<String, dynamic> userLocation, Map<String, dynamic> driverLocation) {
    LatLng userLatLng =
        LatLng(userLocation['latitude'], userLocation['longitude']);
    LatLng driverLatLng =
        LatLng(driverLocation['latitude'], driverLocation['longitude']);

    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      points: [userLatLng, driverLatLng],
      width: 3,
    );

    setState(() {
      _polylines.add(polyline);
    });

    mapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(
          userLatLng.latitude < driverLatLng.latitude
              ? userLatLng.latitude
              : driverLatLng.latitude,
          userLatLng.longitude < driverLatLng.longitude
              ? userLatLng.longitude
              : driverLatLng.longitude,
        ),
        northeast: LatLng(
          userLatLng.latitude > driverLatLng.latitude
              ? userLatLng.latitude
              : driverLatLng.latitude,
          userLatLng.longitude > driverLatLng.longitude
              ? userLatLng.longitude
              : driverLatLng.longitude,
        ),
      ),
      100,
    ));
  }
}
