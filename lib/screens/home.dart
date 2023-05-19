// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_driver_app/assistants/assistantmethods.dart';
import 'package:in_driver_app/providers/appDataprovider.dart';
import 'package:in_driver_app/screens/searchscreen.dart';

import '../Models/addressModel.dart';
import '../widgets/divider_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String idScreen = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Address fetchaddress = Address();

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? _secondGoogleMap;
  //use to get current position on map
  Position? currentPosition;
  //instance of geo locator
  var geoLocator = Geolocator();
  double bottomPadding = 0;
  //function for getting user current location
  final geolocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  void locatePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    Position positon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = positon;
//use to get current latitude of user location
    LatLng latitudePosition = LatLng(positon.latitude, positon.longitude);

    //camera movement
    CameraPosition cameraPosition =
        CameraPosition(target: latitudePosition, zoom: 14);

    CameraUpdate.newCameraPosition(cameraPosition);

    String address =
        await AssitantMethods.searchCordinatesAddress(positon, context);
    print("This is your address ::" + address);
    setState(() {
      fetchaddress = Address(placeName: address);
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            )
          ],
          backgroundColor: Colors.blueGrey,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(CupertinoIcons.person_alt_circle),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Handle Home button tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  // Handle Profile button tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle Settings button tap
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Handle Logout button tap
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              padding: EdgeInsets.only(bottom: bottomPadding),
              //  minMaxZoomPreference: MinMaxZoomPreference(14, 2),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                _secondGoogleMap = controller;
                locatePosition();
                setState(() {
                  bottomPadding = 300;
                });
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 300,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                        "Where to?",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, SearchScreen.idScreen);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              const BoxShadow(
                                blurRadius: 6.0,
                                spreadRadius: 0.3,
                                color: Colors.black54,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: Colors.red,
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
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      //home row
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Home"),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                //fetchaddress.placeName,
                                Provider.of<AppData>(context).pickuplocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickuplocation
                                        .placeName
                                    : "Add Home Address",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    overflow: TextOverflow.visible),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const DividerWidget(),
                      //work row
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Work"),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                "Your office addres",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> getPlaceDirectins() async {
    var init_pos = Provider.of<AppData>(context).pickuplocation;
    var fin_pos = Provider.of<AppData>(context).dropofflocation;
    var pickupLatLang = LatLng(init_pos.lattitude, init_pos.longitude);

    var dropoffLatLang = LatLng(fin_pos.lattitude, fin_pos.longitude);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Dialog Title'),
          content: Container(
            height: 50,
            child: Column(
              children: [Text('loading....'), LinearProgressIndicator()],
            ),
          ),
        );
      },
    );
    var details = await AssitantMethods.obtainDirectionDetails(
        pickupLatLang, dropoffLatLang);
    Navigator.pop(context);

    print("This is encoded points");
    print(details.endcodedpoints);
  }
}
