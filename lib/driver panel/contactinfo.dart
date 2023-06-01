import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
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
    // GoogleMapController mapController = await _controllerGoogleMap.future;
    // location.onLocationChanged.listen((newLoc) {
    //   currentLocation = newLoc;
    //   mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLoc.latitude as double, newLoc.longitude as double))));
    // });
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
      backgroundColor: backgroundColor,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: height - 200,
              width: width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 400,
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
                  ),
                  Positioned(
                    top: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: circleRadius / 2.0),
                      child: Container(
                        width: width - 20,
                        height: 800,
                        decoration: BoxDecoration(
                          color: IconColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: circleRadius / 2.0),
                          child: Container(
                            width: width - 100,
                            height: height / 2.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Container(
                          width: circleRadius,
                          height: circleRadius,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/dp.jpg',
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .5 / 120,
                              ),
                              Text(
                                "George Smith",
                                style:
                                    TextStyle(fontSize: 17, letterSpacing: 2),
                              ),
                              Text(
                                "654 - UKW",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              RatingBarIndicator(
                                rating: 3,
                                itemCount: 5,
                                itemSize: 20.0,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              Container(
                                height: 150,
                                width: width / 1.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
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
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Text("105 Willaim St,Chicago",
                                                    style:
                                                        TextStyle(fontSize: 16))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Image(
                                                    image: AssetImage(
                                                        'assets/images/cardlogo.png')),
                                              ),
                                              Text(
                                                "\$75.00",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
