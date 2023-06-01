// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_driver_app/driver%20panel/riderequest.dart';
import 'package:in_driver_app/screens/ridehistory.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistantmethods.dart';
import '../models/addressModel.dart';
import '../widgets/myColors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _secondGoogleMap;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  LatLng currentLatLng = LatLng(0.0,0.0);
  Address fetchaddress = Address();
  late GoogleMapController _newgoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double _rating = 0;
  TextEditingController notes = TextEditingController();

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

  void getCurrentLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  void setCustomMarkerId() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/current_marker.png")
        .then((icon) {
      currentIcon = icon;
    });
  }
  
  @override
  void initState() {
    super.initState();
    getCurrentLatLng();
    setCustomMarkerId();
    print("init");
  }
  
  @override
  Widget build(BuildContext context) {
    Set<Marker> mapMarkers = {
      Marker(
          markerId: const MarkerId("current_position"),
          position: LatLng(currentLatLng.latitude,currentLatLng.longitude),
          icon: currentIcon)
    };
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    const double circleRadius = 80.0;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: Theme.of(context).primaryColor ,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                  const SizedBox(
                        height: 0,
                      ),
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(CupertinoIcons.person_alt_circle),
                      ),
                      Text(
                              "George Smith",
                              style:
                                  TextStyle(fontSize: 17, letterSpacing: 2),
                            )
                      ]),
                )
                ),
              ListTile(
                leading: Icon(Icons.car_crash_outlined , color: Colors.white,),
                title: Text("Ride Request", style: TextStyle(color: Colors.white),),
                onTap: (){
                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RidesHistory(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.drive_eta, color: Colors.white,),
                title: Text("Ride History", style: TextStyle(color: Colors.white),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RidesHistory(),));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
              child: InkWell(
                onTap: (){
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: ImageIcon(
                  AssetImage("assets/images/menu.png"),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: IconColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: circleRadius / 2.0),
                        child: Container(
                          width: width - 20,
                          height: height-150,
                          decoration: BoxDecoration(
                              color: IconColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: width,
                            height: height / 1.3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(
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
                            SizedBox(
                              height: height / 80,
                            ),
                            Text(
                              "654 - UKW",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RatingBar.builder(
                              initialRating: 3.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30.0,
                              unratedColor: Colors.grey[300],
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                 // _rating = rating;
                                });
                              },
                            ),
                            Container(
                              height: height / 3,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Card(
                                        elevation: 5,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.circle_outlined,
                                            color: IconColor,
                                            size: 20,
                                          ),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10),
                                            child: RatingBar.builder(
                                              initialRating: _rating,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              unratedColor: Colors.grey[300],
                                              itemBuilder: (context, _) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                 // _rating = rating;
                                                });
                                              },
                                            ),
                                          ),
                                          title: Text("Driver Rating"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Card(
                                        elevation: 5,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.circle_outlined,
                                            color: IconColor,
                                            size: 20,
                                          ),
                                          trailing: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text("150")),
                                          title: Text("Rides "),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Card(
                                        elevation: 5,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.circle_outlined,
                                            color: IconColor,
                                            size: 20,
                                          ),
                                          trailing: Text("\$ 1400"),
                                          title: Text("Earning"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                height: height/3,
                                width: width-30,
                                child: GoogleMap(
                                            myLocationEnabled: false,
                                            zoomControlsEnabled: true,
                                            zoomGesturesEnabled: true,
                                            mapType: MapType.normal,
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class progressTile extends StatefulWidget {
  const progressTile({
    super.key,
  });

  @override
  State<progressTile> createState() => _progressTileState();
}

class _progressTileState extends State<progressTile> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(
            Icons.circle_outlined,
            color: IconColor,
            size: 20,
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0,
              unratedColor: Colors.grey[300],
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
          title: Text("Driver Rating"),
        ),
      ),
    );
  }
}
