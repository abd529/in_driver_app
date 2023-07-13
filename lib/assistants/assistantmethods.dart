import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_driver_app/Models/addressModel.dart';
import 'package:in_driver_app/Models/direction_details_model.dart';
import 'package:in_driver_app/assistants/requestassistant.dart';
import 'package:in_driver_app/providers/appDataprovider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class AssitantMethods {
  static Future<String> searchCordinatesAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$map";
    var response = await RequestAssistant.getRequest(url);
    if (response != "Failed") {
      //placeAddress = response["results"][0]["formatted_address"];

      // st1 = response["results"][0]["address_components"][0]["long_name"];
      // st2 = response["results"][0]["address_components"][1]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = "st1,$st2,$st3,$st4";
      Address userpickupAddress = Address();
      userpickupAddress.lattitude = position.latitude;
      userpickupAddress.longitude = position.longitude;
      userpickupAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickupLocatio(userpickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=YOUR_API_KEY";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "Failed") {
      return Future.value(null);
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.endcodedpoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["distance"]["value"];
    directionDetails.durationText = res["routes"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["duration"]["value"];
    return directionDetails;
  }

  static void getCurrentUserinfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("users").child(userId);
    reference.once().then((DataSnapshot dataSnapshot) {
          if (dataSnapshot.value != null) {
            //  usercurrentinfo = User.fromSnapshot(dataSnapshot);
          }
        } as FutureOr Function(DatabaseEvent value));
  }
}
