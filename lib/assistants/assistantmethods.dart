import 'package:geolocator/geolocator.dart';
import 'package:in_driver_app/assistants/requestassistant.dart';

import '../constants.dart';

class AssitantMethods {
  static Future<String> searchCordinatesAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$map";
    var response = await RequestAssistant.getRequest(url);
    if (response != "Failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}
