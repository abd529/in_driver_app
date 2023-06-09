// ignore_for_file: unnecessary_new, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/Models/addressModel.dart';
import 'package:in_driver_app/Models/placeprediction.dart';
import 'package:in_driver_app/assistants/requestassistant.dart';
import 'package:in_driver_app/constants.dart';
import 'package:in_driver_app/providers/appDataprovider.dart';
import 'package:in_driver_app/widgets/divider_widget.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class SearchScreen extends StatefulWidget {
  static const String idScreen = 'searchscreen ';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

TextEditingController pickuplocationcontroller = TextEditingController();

TextEditingController destinationcontroller = TextEditingController();
List<PlacesPredictions> placespredictionlist = [];

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    String pickupaddress =
        Provider.of<AppData>(context).pickuplocation.placeName;
    pickuplocationcontroller.text = pickupaddress;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2.9,
                        blurRadius: 8.0,
                        offset: Offset(0.7, 0.7)),
                  ]),
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.chevron_back,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    title: const Text(
                      "Search Drop off",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/pick.png"),
                          //   color: Color(0xFF3A5A98),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: pickuplocationcontroller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 5), // <-- SEE HERE

                                    hintText: "  Enter your location",
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.pinkAccent),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/destination.png"),
                          //   color: Color(0xFF3A5A98),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  onChanged: (val) {
                                    findplaceName(val);
                                  },
                                  controller: destinationcontroller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 5), // <-- SEE HERE

                                    hintText: "  Enter destination address",
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.pinkAccent),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          (placespredictionlist.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return PredicitionTile(
                          placepredictions: placespredictionlist[index],
                        );
                      },
                      itemCount: placespredictionlist.length,
                      shrinkWrap: true,
                      // physics: ClampingScrollPhysics(),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
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
        var placeslist = (predictions as List)
            .map((e) => PlacesPredictions.fromJson(e))
            .toList();
        setState(() {
          placespredictionlist = placeslist;
        });
        print("Place Predictions are::");
        print(res);
      }
    }
  }
}

class PredicitionTile extends StatelessWidget {
  final PlacesPredictions placepredictions;

  //final StructuredFormatting structure;
  const PredicitionTile({super.key, required this.placepredictions});
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
            SizedBox(
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
                  Icon(Icons.add_location),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placepredictions.main_text.toString(),
                          style: TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          placepredictions.main_text.toString(),
                          style: TextStyle(
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

  void getPlacesDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Dialog Title'),
          content: Container(
            height: 50,
            child: Column(
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
          .updatedropofflocation(address);
      print("This is a dropofflocation::");
      print(address.placeName);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pop(context, "obtainDirection");
    }
  }
}
