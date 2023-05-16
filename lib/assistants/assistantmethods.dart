import 'package:geolocator/geolocator.dart';

class AssitantMethods {
  static Future<String> searchCordinatesAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyATM0ok3Nn_739JDsbyMO8KFTdD4jgU85Q";
  }
}
