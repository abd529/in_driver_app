import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  final _database = FirebaseDatabase.instance.reference();
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  @override
  void dispose() {
    
    super.dispose();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Future<void> _trackme() async {
    //it will call location api every 3 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");
      _database.child('liveLocation').child("location").set({
        "Latitude": position.latitude,
        "Longitude":position.longitude,
      });
      animateLocation(position.latitude, position.longitude);
    });  
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

  @override
  Widget build(BuildContext context) {
     
  
    return Scaffold(
      body: SafeArea(
        child: Stack(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                _controllerGoogleMap.complete(controller);
              },
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ElevatedButton(onPressed: (){_trackme();}, child: const Text("Live Location"))),
            Positioned(
              bottom: 0,
              left: 0,
              child: ElevatedButton(onPressed:(){} , child: const Text("Animate"))),
          ],
        ),
      ),
    );
  }
}