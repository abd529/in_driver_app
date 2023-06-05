import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../constants.dart';

class RideRequestScreen1 extends StatefulWidget {
  @override
  _RideRequestScreen1State createState() => _RideRequestScreen1State();
}

class _RideRequestScreen1State extends State<RideRequestScreen1> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final DatabaseReference _rideRequestRef =
      FirebaseDatabase.instance.reference().child('ride_requests');

  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  PolylinePoints _polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _pickupLocation = LatLng(position.latitude, position.longitude);
      _updatePickupMarker();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updatePickupMarker() {
    if (_pickupLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('pickup'),
            position: _pickupLocation!,
          ),
        );
      });
    }
  }

  void _updateDestinationMarker() {
    if (_destinationLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: _destinationLocation!,
          ),
        );
      });
    }
  }

  void _searchLocations(String query) async {
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      Location firstResult = locations.first;
      setState(() {
        _destinationLocation =
            LatLng(firstResult.latitude, firstResult.longitude);
        _updateDestinationMarker();
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_destinationLocation!),
        );
        _drawPolyline();
      });
    }
  }

  void _drawPolyline() async {
    if (_pickupLocation == null || _destinationLocation == null) {
      return;
    }

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      map,
      PointLatLng(_pickupLocation!.latitude, _pickupLocation!.longitude),
      PointLatLng(
          _destinationLocation!.latitude, _destinationLocation!.longitude),
      travelMode: TravelMode.driving,
    );

    List<LatLng> polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  void _sendRideRequest() {
    if (_pickupLocation == null || _destinationLocation == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Required'),
            content: Text('Please enter a valid location and destination.'),
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
      return;
    }

    // Create a new ride request in the database
    DatabaseReference newRideRequestRef = _rideRequestRef.push();
    String requestId = newRideRequestRef.key!;
    newRideRequestRef.set({
      'pickup_location': {
        'latitude': _pickupLocation!.latitude,
        'longitude': _pickupLocation!.longitude,
      },
      'destination_location': {
        'latitude': _destinationLocation!.latitude,
        'longitude': _destinationLocation!.longitude,
      },
      'status': 'pending',
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ride Request Sent'),
          content: Text('Your ride request has been sent.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Request'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Enter Location',
            ),
            onChanged: (value) {
              _searchLocations(value);
            },
          ),
          TextFormField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Enter Destination',
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _pickupLocation ?? LatLng(0, 0),
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          ElevatedButton(
            onPressed: _sendRideRequest,
            child: Text('Request Ride'),
          ),
        ],
      ),
    );
  }
}
