import 'package:geolocator/geolocator.dart';
import 'package:in_driver_app/Models/addressModel.dart';
import 'package:in_driver_app/assistants/requestassistant.dart';
import 'package:in_driver_app/controllers/appDataprovider.dart';

import '../constants.dart';
import 'package:provider/provider.dart';

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

      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = "$st1,$st2,$st3,$st4";
      Address userpickupAddress = Address();
      userpickupAddress.lattitude = position.latitude;
      userpickupAddress.longitude = position.longitude;
      userpickupAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickupLocatio(userpickupAddress);
    }
    return placeAddress;
  }
}
