// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  static const String idScreen = 'home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? _secondGoogleMap;

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
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            _secondGoogleMap = controller;
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 250,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                      color: Colors.black,
                      offset: Offset(0.7, 0.7))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    "Hi,there",
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    "Where to",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          spreadRadius: 0.3,
                          color: Colors.black54,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.yellowAccent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Search Drop off",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
