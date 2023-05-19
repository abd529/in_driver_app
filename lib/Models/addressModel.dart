// ignore_for_file: file_names

class Address {
  String placeFormattedAddress;
  String placeName;
  String placeId;
  double lattitude;
  double longitude;

  Address({
    this.placeId = "",
    this.placeName = "loading...",
    this.placeFormattedAddress = "ll",
    this.lattitude = 0.0,
    this.longitude = 0.0,
  });
}
