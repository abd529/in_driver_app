// ignore_for_file: prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, cast_from_null_always_fails, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_driver_app/Models/addressModel.dart';
import 'package:in_driver_app/assistants/assistantmethods.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:in_driver_app/auth/signup.dart';
import 'package:in_driver_app/models/ride.dart';
import 'package:in_driver_app/providers/appDataprovider.dart';
import 'package:in_driver_app/constants.dart';
import 'package:in_driver_app/screens/paymentmethod.dart';
import 'package:in_driver_app/screens/ratingscreen.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import '../assistants/requestassistant.dart';
import '../auth/login.dart';
import '../driver panel/notify_controller.dart';
import '../main.dart';
import '../models/placeprediction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/myColors.dart';
import 'Mywallet.dart';
import 'language_select.dart';
import 'package:firebase_database/firebase_database.dart';

import 'live_location.dart';

class HomePage extends StatefulWidget {
  static String idScreen = 'home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng current = const LatLng(0, 0);
  int bidAmount = 0;
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

  int index = 1;
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
      print("This is a dropofflocation:: $address");
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

  void _listenForAcceptedRides() {
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
              content: SizedBox(
                height: 250,
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 82,
                    ),
                    Text(
                      "Booking Successful",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      "Your ride request has been accepted by a driver, please accept or decline the ride and the rider will pick you up in 5 minutes",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    
                  },
                  child: const Text('Decline Offer',
                      style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    setState(() {
                      nextCheck = 3;
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LiveLocation()));
                    });
                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
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

  void _requestRide(int fare) {
    String pickupLocation = pickUpController.text;
    String destination = dropOffController.text;
    String id = userId;
    String status = "pending";
    if (pickupLocation.isNotEmpty && destination.isNotEmpty) {
      // Store ride request details in Firebase Realtime Database
      _database.child('rideRequests').child(id).set({
        'pickupLocation': pickupLocation,
        'destination': destination,
        'fare': fare,
        'rideRequestId': id,
        'status': status
      }).then((value) {
        // Success, ride request details are stored
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ride Request'),
              content: const Text('Ride request sent successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ride Request'),
              content:
                  const Text('Failed to send ride request. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
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
            title: const Text('Ride Request'),
            content: const Text(
                'Please enter both pickup location and destination.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
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
      
      print(res);
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

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAQdieV_0:APA91bHZqyu50fe_VqgkFnzr2R0aGtaeckWueKLTtzsCTt5mjXWYRigAhDHpMK2VzvA8jDN_R3EKJ7-jwXAyuZensUGhbDS6mVmcC8ZRM-nfKP5sR29xPBZx4tDoR62F3L_FCMjGr0Vo',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'token': token,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    } catch (e) {
      print("error push notification");
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print(
        "permission okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  }

  Set<Marker> mapMarkers = {};

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    getCurrentLatLng();
    setCustomMarkerId();
    requestPermission();
    _listenForAcceptedRides();
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) {
      return NotificationController.onActionReceivedMethod(
        receivedAction,
        context,
      );
    });
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
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              myBackgroundMessageHandler(message);
            }));
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
            "University Bus Tracking",
            style: TextStyle(color: Colors.white),
          ),
          // actions: [
          //    Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: IconButton(
          //       onPressed: (){
          //         print(userId);
          //       },
          //       icon: const Icon(Icons.settings,
          //       color: Colors.white,),
                
          //     ),
          //   )
          // ],
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
                    builder: (context) => const AuthHome(),
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
                            ? 420
                            : 420,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
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
                                  decoration: textFeildDecore("Pickup"),
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
                                  decoration: textFeildDecore("Drop off"),
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
                                  decoration: textFeildDecore("Fare"),
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
                                                        placespredictionlist =
                                                            [];
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
                                                      placespredictionlist[
                                                          index];
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
                                                        placespredictionlist =
                                                            [];
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
                                                // ElevatedButton(onPressed: ()async{
                                                //   GoogleMapController controller = await _controllerGoogleMap.future;
                                                //   controller.animateCamera(CameraUpdate.newCameraPosition(
                                                //     const CameraPosition(
                                                //       target: LatLng(
                                                //         38.4237,27.1428
                                                //       ),
                                                //       zoom: 14,
                                                //     ),
                                                //   ));
                                                //   setState(() {});
                                                // }, child: const Text("animate")),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setPolylines(
                                                          pickUp, dropOff);
                                                      setState(() {
                                                        nextCheck = 1;
                                                        bidAmount = int.parse(
                                                            fareController
                                                                .text);
                                                      });
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  60,
                                                                  20,
                                                                  60,
                                                                  20),
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
                                                // ElevatedButton(
                                                //   onPressed: () {
                                                //     _requestRide();
                                                //   },
                                                //   child: Text('RR'),
                                                // ),
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
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                            )),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                          ),
                                        ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Your proposed bid: PKR ${fareController.text}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
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
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Any Comments",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
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
                                          _requestRide(bidAmount);
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
                            : nextCheck == 2
                                ? Column(children: [
                                    const Text(
                                        "All Rides near you are infromed about your ride request"),
                                    SizedBox(
                                      //height: 280,
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Negotiate",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          45))),
                                                  onPressed: () {
                                                    //farenegpminus();
                                                    setState(() {
                                                      bidAmount = bidAmount - 5;
                                                      print(bidAmount);
                                                    });
                                                  },
                                                  child: const Text(
                                                    "-5",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Current Bid",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      "\$$bidAmount",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45))),
                                                    onPressed: () {
                                                      //farenegplus();
                                                      setState(() {
                                                        bidAmount =
                                                            bidAmount + 5;
                                                        print(bidAmount);
                                                      });
                                                    },
                                                    child: const Text(
                                                      "+5",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 240,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          45))),
                                                  onPressed: () {
                                                    _requestRide(bidAmount);
                                                    sendPushMessage(
                                                        "A customer is waiting for your response",
                                                        "100",
                                                        "eWEE_ZnFTz6IRzjN3fgjI7:APA91bEDZsvdC-0ldxBvzAJy5s0dfxBO4GsMN2ZqmEKiIlKIOC4nTw3Vgy4fm2TxKicNItDjLtptmSUTSIQXbBIkIpWwYZkBrakjgm9yUjjluGZLV7ApXm-Xd20CXkoW-X2frl16v0gz");
                                                  },
                                                  child: const Text(
                                                    "Request Again",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  )),
                                            ),
                                            SizedBox(height: 30,),
                                            SizedBox(
                                              height: 50,
                                              width: 240,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          45))),
                                                  onPressed: () {
                                                    
                                                    },
                                                  child: const Text(
                                                    "Rate Driver",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  )),
                                            ),
                                            
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // SizedBox(
                                            //   height: 50,
                                            //   width: 240,
                                            //   child: ElevatedButton(
                                            //       style: ElevatedButton.styleFrom(
                                            //           shape: RoundedRectangleBorder(
                                            //               borderRadius: BorderRadius.circular(45))),
                                            //       onPressed: () {
                                            //         showDialog(
                                            //           context: context,
                                            //           builder: (BuildContext context) {
                                            //             return AlertDialog(
                                            //               content: Container(
                                            //                 decoration: BoxDecoration(
                                            //                     borderRadius:
                                            //                         BorderRadius.circular(50)),
                                            //                 height: 300,
                                            //                 child: Column(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment.center,
                                            //                   crossAxisAlignment:
                                            //                       CrossAxisAlignment.center,
                                            //                   children: [
                                            //                     Icon(
                                            //                       Icons.remove_done_sharp,
                                            //                       color: Colors.red,
                                            //                       size: 100,
                                            //                     ),
                                            //                     SizedBox(
                                            //                       height: 30,
                                            //                     ),
                                            //                     Text(
                                            //                       'Booking Cancelled',
                                            //                       style: TextStyle(
                                            //                           fontSize: 20,
                                            //                           fontWeight: FontWeight.bold),
                                            //                     ),
                                            //                     SizedBox(
                                            //                       height: 10,
                                            //                     ),
                                            //                     Text(
                                            //                       'Your booking has been  successfully cancelled.',
                                            //                       textAlign: TextAlign.center,
                                            //                       style: TextStyle(
                                            //                           fontSize: 12,
                                            //                           fontWeight: FontWeight.normal),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ),
                                            //               actions: [
                                            //                 Row(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment.spaceBetween,
                                            //                   children: [
                                            //                     MaterialButton(
                                            //                       child: Text('Cancel'),
                                            //                       onPressed: () {
                                            //                         Navigator.of(context).pop();
                                            //                       },
                                            //                     ),
                                            //                     MaterialButton(
                                            //                       child: Text(
                                            //                         'Done',
                                            //                         style:
                                            //                             TextStyle(color: Colors.green),
                                            //                       ),
                                            //                       onPressed: () {},
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ],
                                            //             );
                                            //           },
                                            //         );
                                            //       },
                                            //       child: Text(
                                            //         "Decline",
                                            //         style: TextStyle(color: Colors.white, fontSize: 20),
                                            //       )),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ])
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                children: [
                                                  const Text("Rider Name"),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: 3,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 10,
                                                        unratedColor:
                                                            Colors.grey[300],
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          setState(() {
                                                            //  _rating = rating;
                                                          });
                                                        },
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Text("3.0")
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          CircleAvatar(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.call)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ImageIcon(
                                              AssetImage(
                                                  "assets/images/car-icon.png"),
                                              size: 40,
                                            ),
                                            Column(
                                              children: [
                                                Text("Distance"),
                                                Text("0.2km")
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Time"),
                                                Text("2 min")
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Fare"),
                                                Text("\$568")
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              RatingScreen.routeName);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              100, 20, 100, 20),
                                          shape: RoundedRectangleBorder(
                                              //to set border radius to button
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                        child: const Text("Let's Go",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              100, 20, 100, 20),
                                          shape: RoundedRectangleBorder(
                                              //to set border radius to button
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                        onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveLocation(),));
                                      }, child: Text("Track Driver", style: TextStyle(color: Colors.white),))
                                    ],
                                  )),
              ),
            )
          ],
        ));
  }

  InputDecoration textFeildDecore(String hint) {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8.0),
      //   borderSide: const BorderSide(
      //     color: Colors.grey,
      //     width: 1.0,
      //   ),
      // ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8.0),
      //   borderSide: const BorderSide(
      //     color: Colors.grey,
      //     width: 1.0,
      //   ),
      // ),
      // focusedBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8.0),
      //   borderSide: const BorderSide(
      //     color: Colors.blue,
      //     width: 1.5,
      //   ),
      // ),
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
        "AIzaSyBUOPRnIBThORPGz-26PjR2YBxymMy5Rdo",
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
