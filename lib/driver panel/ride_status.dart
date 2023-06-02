// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_driver_app/Models/addressModel.dart';
import 'package:in_driver_app/assistants/assistantmethods.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/auth/signup.dart';
import 'package:in_driver_app/models/ride.dart';
import 'package:in_driver_app/providers/appDataprovider.dart';
import 'package:in_driver_app/constants.dart';
import 'package:in_driver_app/screens/paymentmethod.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import '../assistants/requestassistant.dart';
import '../auth/login.dart';
import '../models/placeprediction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/myColors.dart';

class RideStatus extends StatefulWidget {
  const RideStatus({super.key});

  @override
  State<RideStatus> createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  LatLng current = const LatLng(0, 0);
  Address fetchaddress = Address();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  TextEditingController fareController = TextEditingController();
  final Set<Polyline> _polylines = <Polyline>{};
  int check = 0;
  List<PlacesPredictions> placespredictionlist = [];
  List<LatLng> polyLineCordinates = [];
  late PolylinePoints polylinePoints;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? _secondGoogleMap;
  Set<Polyline> polylineset = {};
  late GoogleMapController _newgoogleMapController;
  Position? currentPosition;
  late Position pickUp;
  late Position dropOff;
  var geoLocator = Geolocator();
  double bottomPadding = 0;
  final geolocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  LocationData? currentLocation;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerId() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/current_marker.png")
        .then((icon) {
      currentIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/start-icon.png")
        .then((icon) {
      startIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/destination-icon.png")
        .then((icon) {
      destinationIcon = icon;
    });
  }

  void getCurrentPosition() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  LatLng currentLatLng = const LatLng(0, 0);
  void getCurrentLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  void locatePosition() async {
    //LocationPermission permission = await Geolocator.checkPermission();
    Position positon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latitudePosition = LatLng(positon.latitude, positon.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latitudePosition, zoom: 14);
    _newgoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssitantMethods.searchCordinatesAddress(positon, context);
    print("This is your address ::$address");
    setState(() {
      fetchaddress = Address(placeName: address);
    });
  }

  void findplaceName(String placeName) async {
    if (placeName.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=37.76999%2C-122.44696&radius=500&types=establishment&key=$map&components=country:pk";
      var res = await RequestAssistant.getRequest(autoComplete);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        print(predictions);
        var placeslist = (predictions as List)
            .map((e) => PlacesPredictions.fromJson(e))
            .toList();
        print(placeslist[0].place_id);
        setState(() {
          placespredictionlist = placeslist;
        });
        print("Place Predictions are::");
        print(res);
      }
    }
  }

  Set<Marker> mapMarkers = {};

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    getCurrentLatLng();
    setCustomMarkerId();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double negotiate = 5;
  farenegplus() {
    setState(() {
      negotiate = negotiate + 5;
    });
  }

  farenegpminus() {
    setState(() {
      if (negotiate > 5) negotiate = negotiate - 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    final double circleRadius = 80.0;
    final double circleBorderWidth = 8.0;
    Set<Marker> mapMarkers = {
      Marker(
          markerId: const MarkerId("current_position"),
          position: currentLatLng,
          icon: currentIcon)
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.left_chevron,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageIcon(
              const AssetImage("assets/images/menu.png"),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: height,
                width: width,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GoogleMap(
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        mapType: MapType.normal,
                        polylines: _polylines,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) async {
                          _controllerGoogleMap.complete(controller);
                          _newgoogleMapController = controller;

                          _secondGoogleMap = controller;
                          locatePosition();
                        },
                        markers: mapMarkers,
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: Padding(
                        padding: EdgeInsets.only(top: circleRadius / 2.0),
                        child: Container(
                          width: width - 60,
                          height: 220,
                          decoration: BoxDecoration(
                              color: IconColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: Container(
                        width: circleRadius,
                        height: circleRadius,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/dp.jpg',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 230,
                      child: Column(children: [
                        SizedBox(
                          height: height * .5 / 120,
                        ),
                        Text(
                          "George Smith",
                          style: TextStyle(fontSize: 17, letterSpacing: 2),
                        ),
                        SizedBox(
                          height: height / 20,
                        ),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/images/history.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "7958 swift Village",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text("105 Willaim St,Chicago",
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: Container(
                width: width,
                color: Colors.white,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Negotiate",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45))),
                          onPressed: () {
                            farenegpminus();
                          },
                          child: Text(
                            "-5",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Current Balance",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              "\$${negotiate.toString()}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45))),
                            onPressed: () {
                              farenegplus();
                            },
                            child: Text(
                              "+5",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      width: 240,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons
                                              .check_mark_circled_solid,
                                          color: IconColor,
                                          size: 100,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Booking Successful',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Your booking has been confirmed.Driver will pickup you in 2 minutes.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        MaterialButton(
                                          child: Text(
                                            'Done',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 240,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.remove_done_sharp,
                                          color: Colors.red,
                                          size: 100,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Booking Cancelled',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Your booking has been  successfully cancelled.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        MaterialButton(
                                          child: Text(
                                            'Done',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Decline",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
