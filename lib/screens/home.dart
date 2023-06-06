// ignore_for_file: prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, cast_from_null_always_fails, unused_field

import 'dart:async';
import 'dart:math';

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
import 'Mywallet.dart';
import 'language_select.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  static String idScreen = 'home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng current = const LatLng(0, 0);
  Address fetchaddress = Address();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  TextEditingController fareController = TextEditingController();
  final Set<Polyline> _polylines = <Polyline>{};
  int check = 0;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
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
  int sizeCheck = 0;
  int nextCheck = 0;
  final List<String> vehicals = [
    "Luxury Vehical",
    "Standard Vehical",
    "Bike",
    "Taxi"
  ];
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const int earthRadius = 6371; // Earth's radius in kilometers

    // Convert degrees to radians
    double startLatRadians = degreesToRadians(startLatitude);
    double startLonRadians = degreesToRadians(startLongitude);
    double endLatRadians = degreesToRadians(endLatitude);
    double endLonRadians = degreesToRadians(endLongitude);

    // Calculate the differences between the coordinates
    double latDiff = endLatRadians - startLatRadians;
    double lonDiff = endLonRadians - startLonRadians;

    // Apply the Haversine formula
    double a = pow(sin(latDiff / 2), 2) +
        cos(startLatRadians) * cos(endLatRadians) * pow(sin(lonDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double calculateFare(double distance) {
    const double ratePerKilometer = 120; // Fare rate per kilometer

    // Calculate the fare based on the distance
    double fare = distance * ratePerKilometer;

    return fare;
  }

  int index = 0;
  final List<Ride> rides = [
    Ride(
        type: "Luxury",
        distance: "0.5 KM",
        imgUrl: "assets/images/luxury.png",
        money: "200"),
    Ride(
        type: "Car",
        distance: "0.5 KM",
        imgUrl: "assets/images/car-icon.png",
        money: "250"),
    Ride(
        type: "Bike",
        distance: "0.5 KM",
        imgUrl: "assets/images/bike.png",
        money: "220"),
    Ride(
        type: "Taxi",
        distance: "0.5 KM",
        imgUrl: "assets/images/taxi.png",
        money: "180"),
  ];

  Future<Address?> getPlacesDetails(String placeId, int check, context) async {
    print("function test 1 ok");
    String placeDetailsurl =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$map";
    var res = await RequestAssistant.getRequest(placeDetailsurl);
    print("function test 2 ok");
    print(res);
    if (res == "failed") {
      print("function failed test 3 ok");
      return null;
    }
    if (res["status"] == "OK") {
      print("function OK test 4 ok");
      print("detail result=======$res");
      Address address = Address();
      if (check == 0) {
        setState(() {
          pickUp = Position(
            latitude: res["result"]["geometry"]["location"]["lat"],
            longitude: res["result"]["geometry"]["location"]["lng"],
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 50,
            speedAccuracy: 1.0,
            timestamp: DateTime.now(),
          );
        });
      }
      if (check == 1) {
        setState(() {
          dropOff = Position(
            latitude: res["result"]["geometry"]["location"]["lat"],
            longitude: res["result"]["geometry"]["location"]["lng"],
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 50,
            speedAccuracy: 1.0,
            timestamp: DateTime.now(),
          );
        });
      }

      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.lattitude = res["result"]["geometry"]["location"]["lat"];

      address.longitude = res["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updatedropofflocation(address as Address);
      print("This is a dropofflocation::");
      return address;
    }
    return null;
  }

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

  void _listenForRideRequests() {
    _rideRequestRef = _database.child('rideRequests');
    _rideRequestRef!.onChildChanged.listen((event) {
      if (event.snapshot.exists) {
        // Retrieve the latest ride request details
        Object? rideRequestData = event.snapshot.value;

        // Perform necessary actions based on the updated ride request details
        // For example, you can update the UI or trigger notifications
        print('New ride request: $rideRequestData');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ride Request'),
              content: Text('New ride request: $rideRequestData'),
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
    });
  }

  final _database = FirebaseDatabase.instance.reference();
  Position? _currentPosition;
  DatabaseReference? _rideRequestRef;

  void _requestRide() {
    String pickupLocation = pickUpController.text;
    String destination = dropOffController.text;
    String id = userId;
    String status = "pending";
    if (pickupLocation.isNotEmpty && destination.isNotEmpty) {
      // Store ride request details in Firebase Realtime Database
      _database.child('rideRequests').child(id).set({
        'pickupLocation': pickupLocation,
        'destination': destination,
        'rideRequestId': id,
        'status': status
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
    _listenForRideRequests();
  }

  @override
  void dispose() {
    pickUpController.dispose();
    dropOffController.dispose();
    _rideRequestRef?.onValue.listen((event) {});
    super.dispose();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    Set<Marker> mapMarkers = {
      Marker(
          markerId: const MarkerId("current_position"),
          position: currentLatLng,
          icon: currentIcon)
    };
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: const Text(
            "inDriver",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          ],
        ),

        // bottomSheet: Container(height: 500,),

        drawer: Drawer(
          width: 240,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: IconColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
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
                      Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cash:"),
                              Text(
                                "2500:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                CupertinoIcons.right_chevron,
                                color: IconColor,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
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
                leading: const Icon(Icons.wallet),
                title: const Text('Wallet'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyWallet()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  // Handle Settings button tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.notification_add_sharp),
                title: const Text('Notifications'),
                onTap: () {
                  // Handle Logout button tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallet_giftcard),
                title: const Text('Invite Friends'),
                onTap: () {
                  // Handle Logout button tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.g_translate),
                title: const Text('Language'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LanguageSel()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AuthHome(),
                  ));
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: false,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              padding: EdgeInsets.only(bottom: bottomPadding),
              mapType: MapType.normal,
              polylines: _polylines,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) async {
                _controllerGoogleMap.complete(controller);
                _newgoogleMapController = controller;

                _secondGoogleMap = controller;
                locatePosition();
                setState(() {
                  bottomPadding = 300;
                });
              },
              markers: mapMarkers,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: sizeCheck == 1
                    ? 550
                    : sizeCheck == 2
                        ? 500
                        : sizeCheck == 0
                            ? 380
                            : 380,
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
                  child: nextCheck == 0
                      ? Form(
                          key: _formKey,
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
                              TextFormField(
                                controller: pickUpController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "pickup location is required";
                                  }
                                },
                                onChanged: (val) {
                                  findplaceName(val);
                                  check = 0;
                                  sizeCheck = 1;
                                },
                                decoration:
                                    textFeildDecore("Enter Pickup Location"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: dropOffController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "drop off location is required";
                                  }
                                },
                                onChanged: (val) {
                                  findplaceName(val);
                                  check = 1;
                                  sizeCheck = 2;
                                },
                                decoration:
                                    textFeildDecore("Enter Drop off Location"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: fareController,
                                onChanged: (val) {
                                  setState(() {
                                    sizeCheck = 0;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "fare is required";
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration:
                                    textFeildDecore("Enter Fare in PKR"),
                              ),
                              (placespredictionlist.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Column(
                                        children: [
                                          check == 0
                                              ? ListTile(
                                                  leading: const Icon(
                                                    Icons
                                                        .location_searching_rounded,
                                                    color: Colors.green,
                                                  ),
                                                  title: const Text(
                                                      "Get your current location"),
                                                  onTap: () async {
                                                    pickUpController.text =
                                                        fetchaddress.placeName
                                                            .toString();
                                                    pickUp = await Geolocator
                                                        .getCurrentPosition(
                                                            desiredAccuracy:
                                                                LocationAccuracy
                                                                    .high);
                                                    setState(() {
                                                      placespredictionlist = [];
                                                    });
                                                  },
                                                )
                                              : const SizedBox(),
                                          SizedBox(
                                            height: 180,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                PlacesPredictions place =
                                                    placespredictionlist[index];
                                                return ListTile(
                                                  leading: const Icon(Icons
                                                      .location_on_outlined),
                                                  title: Text(place.main_text
                                                      .toString()),
                                                  onTap: () async {
                                                    Address? add =
                                                        await getPlacesDetails(
                                                            place.place_id
                                                                .toString(),
                                                            check,
                                                            context);
                                                    if (check == 0) {
                                                      pickUpController.text =
                                                          add!.placeName
                                                              .toString();
                                                    } else if (check == 1) {
                                                      dropOffController.text =
                                                          add!.placeName
                                                              .toString();
                                                    }
                                                    setState(() {
                                                      placespredictionlist = [];
                                                    });
                                                  },
                                                );
                                              },
                                              itemCount:
                                                  placespredictionlist.length,
                                              shrinkWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // ElevatedButton(
                                              //     onPressed: () {
                                              //       double distance =
                                              //           calculateDistance(
                                              //               pickUp.latitude,
                                              //               pickUp.longitude,
                                              //               dropOff.latitude,
                                              //               dropOff.longitude);

                                              //       double fare =
                                              //           calculateFare(distance);

                                              //       print("fare ${fare}");
                                              //     },
                                              //     child: Text("fare")),
                                              // ElevatedButton(
                                              //     onPressed: () {
                                              //       print(
                                              //           "dissssssssssstanceeeeeeeeee ${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude)}");
                                              //     },
                                              //     child: Text("dis")),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setPolylines(
                                                        pickUp, dropOff);
                                                    setState(() {
                                                      // nextCheck = 1;
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        60, 20, 60, 20),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            //to set border radius to button
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50))),
                                                child: const Text(
                                                  "Find Route",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _requestRide();
                                                },
                                                child: Text('RR'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        )
                      : nextCheck == 1
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Card(
                                    elevation: 2,
                                    color: Colors.grey[100],
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 0;
                                                });
                                              },
                                              child: const ImageIcon(
                                                AssetImage(
                                                    "assets/images/luxury.png"),
                                                size: 40,
                                              )),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 1;
                                                });
                                              },
                                              child: const ImageIcon(
                                                AssetImage(
                                                    "assets/images/car-icon.png"),
                                                size: 40,
                                              )),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 2;
                                                });
                                              },
                                              child: const ImageIcon(
                                                AssetImage(
                                                    "assets/images/bike.png"),
                                                size: 40,
                                              )),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index = 3;
                                                });
                                              },
                                              child: const ImageIcon(
                                                AssetImage(
                                                    "assets/images/taxi.png"),
                                                size: 40,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                          value: true,
                                          activeColor: Colors.grey[800],
                                          groupValue: true,
                                          onChanged: (boolean) {}),
                                      Container(
                                          height: 50,
                                          child: Text(
                                            "Pickup Location:\n${pickUpController.text}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            softWrap: true,
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                          value: true,
                                          activeColor: Colors.grey[800],
                                          groupValue: true,
                                          onChanged: (boolean) {}),
                                      Container(
                                          height: 50,
                                          child: Text(
                                            "Destination Location: \n${dropOffController.text}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Your proposed budget: PKR ${fareController.text}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("Selected Vehical: ${vehicals[index]}"),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        nextCheck = 2;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(
                                            100, 20, 100, 20),
                                        shape: RoundedRectangleBorder(
                                            //to set border radius to button
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    child: const Text(
                                      "Find Riders",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            )
                          : Column(children: [
                              const Text("All Rides near you"),
                              Container(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: rides.length,
                                  itemBuilder: (context, index) {
                                    Ride ride = rides[index];
                                    return Card(
                                      elevation: 3,
                                      child: ListTile(
                                        leading:
                                            ImageIcon(AssetImage(ride.imgUrl)),
                                        title: Text(ride.type),
                                        subtitle: Text(ride.distance),
                                        trailing: Text("PKR ${ride.money}"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]),
                ),
              ),
            )
          ],
        ));
  }

  InputDecoration textFeildDecore(String hint) {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
      hintText: hint,
    );
  }

  Future<void> getPlaceDirectins() async {
    var initalpos = Provider.of<AppData>(context).pickuplocation;
    var finalpos = Provider.of<AppData>(context).dropofflocation;
    var pickupLatLang = LatLng(initalpos.lattitude, initalpos.longitude);

    var dropoffLatLang = LatLng(finalpos.lattitude, finalpos.longitude);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Dialog Title'),
          content: Container(
            height: 50,
            child: const Column(
              children: [Text('loading....'), LinearProgressIndicator()],
            ),
          ),
        );
      },
    );
    var details = await AssitantMethods.obtainDirectionDetails(
        pickupLatLang, dropoffLatLang);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    print("This is encoded points");
    print(details.endcodedpoints);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedpolylinepointsResult =
        polylinePoints.decodePolyline(details.endcodedpoints.toString());
    polyLineCordinates.clear();
    if (decodedpolylinepointsResult.isEmpty) {
      decodedpolylinepointsResult.forEach((PointLatLng pointLatLng) {
        polyLineCordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineset.clear();
    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId("PolylineId"),
          color: Colors.pink,
          jointType: JointType.round,
          points: polyLineCordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineset.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickupLatLang.latitude > dropoffLatLang.latitude &&
        pickupLatLang.longitude > dropoffLatLang.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropoffLatLang, northeast: pickupLatLang);
    } else if (pickupLatLang.longitude > dropoffLatLang.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupLatLang.latitude, dropoffLatLang.latitude),
          northeast: LatLng(dropoffLatLang.longitude, pickupLatLang.longitude));
    } else if (pickupLatLang.latitude > dropoffLatLang.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropoffLatLang.latitude, pickupLatLang.latitude),
          northeast: LatLng(pickupLatLang.longitude, dropoffLatLang.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickupLatLang, northeast: dropoffLatLang);
    }
    _newgoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

  void setPolylines(Position current, Position dropOff) async {
    setState(() {
      polyLineCordinates = [];
    });
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyATM0ok3Nn_739JDsbyMO8KFTdD4jgU85Q",
        PointLatLng(current.latitude, current.longitude),
        PointLatLng(dropOff.latitude, dropOff.longitude));
    if (result.status == "OK") {
      print(result.points);
      result.points.forEach((PointLatLng point) {
        polyLineCordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {
          mapMarkers.add(Marker(
              markerId: const MarkerId("start marker id"),
              position: LatLng(current.latitude, current.longitude),
              icon: startIcon));
          mapMarkers.add(Marker(
              markerId: const MarkerId("destination marker id"),
              position: LatLng(dropOff.latitude, dropOff.longitude),
              icon: startIcon));
          _polylines.add(Polyline(
              polylineId: const PolylineId("polyline"),
              width: 6,
              color: Colors.deepPurple,
              points: polyLineCordinates));
        });
      });
      setState(() {});
    }
  }
}

class PredicitionTile extends StatelessWidget {
  final PlacesPredictions placepredictions;
  // final TextEditingController controller;

  //final StructuredFormatting structure;
  const PredicitionTile({super.key, required this.placepredictions});

  void getPlacesDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Dialog Title'),
          content: Container(
            height: 50,
            child: const Column(
              children: [Text('loading....'), LinearProgressIndicator()],
            ),
          ),
        );
      },
    );

    String placeDetailsurl =
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$map";
    var res = await RequestAssistant.getRequest(placeDetailsurl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.lattitude = res["result"]["geometry"]["location"]["lat"];

      address.longitude = res["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updatedropofflocation(address as Address);
      print("This is a dropofflocation::");
      print(address.placeName);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pop(context, "obtainDirection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getPlacesDetails(placepredictions.place_id.toString(), context);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                // Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.add_location),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placepredictions.main_text.toString(),
                          style: const TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          placepredictions.main_text.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
