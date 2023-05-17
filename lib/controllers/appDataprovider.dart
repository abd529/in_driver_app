import 'package:flutter/foundation.dart';
import 'package:in_driver_app/Models/addressModel.dart';

class AppData extends ChangeNotifier {
  Address pickuplocation = Address();
  void updatePickupLocatio(Address pickupaddress) {
    {
      pickuplocation = pickupaddress;
    }
    notifyListeners();
  }
}
