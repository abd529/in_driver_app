import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DriverScreenLive extends StatefulWidget {
  const DriverScreenLive({Key? key}) : super(key: key);

  @override
  State<DriverScreenLive> createState() => _DriverScreenLiveState();
}

class _DriverScreenLiveState extends State<DriverScreenLive> {
  final _database = FirebaseDatabase.instance.reference();

  Timer? _timer;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateDriverLocation();
    });
  }

  Future<void> _updateDriverLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    _database.child('liveLocation').child('location').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Module'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentPosition != null)
              Text(
                'Latitude: ${_currentPosition!.latitude}\n'
                'Longitude: ${_currentPosition!.longitude}',
                textAlign: TextAlign.center,
              ),
            ElevatedButton(
              onPressed: _updateDriverLocation,
              child: const Text('Update Location'),
            ),
          ],
        ),
      ),
    );
  }
}
