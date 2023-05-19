import 'package:flutter/foundation.dart';
import 'package:in_driver_app/Models/addressModel.dart';

class AppData extends ChangeNotifier {
  Address pickuplocation = Address();
  Address dropofflocation = Address();
  void updatePickupLocatio(Address pickupaddress) {
    {
      pickuplocation = pickupaddress;
    }
    notifyListeners();
  }

  void updatedropofflocation(Address dropoffaddress) {
    {
      dropofflocation = dropoffaddress;
    }
    notifyListeners();
  }
}
