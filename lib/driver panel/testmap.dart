import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  GoogleMapController? _mapController;
  TextEditingController _pickupLocationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  final _database = FirebaseDatabase.instance.reference();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  Polyline? _polyline;
  DatabaseReference? _rideRequestRef;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenForRideRequests();
  }

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _destinationController.dispose();
    _rideRequestRef?.onValue.listen((event) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Request'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      37.7749, -122.4194), // Initial map center coordinates
                  zoom: 13.0, // Initial map zoom level
                ),
                markers: _markers,
                polylines: Set<Polyline>.from([
                  if (_polyline != null) _polyline!,
                ]),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _pickupLocationController,
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _requestRide();
              },
              child: Text('Request Ride'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _showLocation();
              },
              child: Text('Show Location'),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _updateCurrentLocationMarker();
        });
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void _updateCurrentLocationMarker() {
    if (_currentPosition != null) {
      final marker = Marker(
        markerId: MarkerId('currentLocation'),
        position:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      );
      setState(() {
        _markers = {
          ...?_markers,
          marker,
        };
      });
    }
  }

  void _requestRide() {
    String pickupLocation = _pickupLocationController.text;
    String destination = _destinationController.text;

    if (pickupLocation.isNotEmpty && destination.isNotEmpty) {
      // Store ride request details in Firebase Realtime Database
      _database.child('rideRequests').push().set({
        'pickup_location': pickupLocation,
        'destination': destination,
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

  void _showLocation() {
    if (_currentPosition != null) {
      LatLng destination = LatLng(
        _currentPosition!.latitude + 0.01,
        _currentPosition!.longitude + 0.01,
      );

      setState(() {
        _polylineCoordinates.clear();
        _polyline = null;
      });

      _createPolylines(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        destination.latitude,
        destination.longitude,
      );
    }
  }

  void _createPolylines(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      'API_KEY', // Replace with your Google Maps API key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(endLatitude, endLongitude),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates.clear();
        for (PointLatLng point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        _polyline = Polyline(
          polylineId: PolylineId('polyline'),
          color: Colors.blue,
          points: _polylineCoordinates,
        );
      });
    }
  }

  void _listenForRideRequests() {
    _rideRequestRef = _database.child('rideRequests');
    _rideRequestRef!.onValue.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Object? rideRequestData = event.snapshot.value;

        // Perform necessary actions based on the updated ride request details
        // For example, you can update the UI or trigger notifications
        print('New ride request: $rideRequestData');
      }
    });
  }
}
