// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_driver_app/screens/ridehistory.dart';

import '../widgets/myColors.dart';

class RatingScreen extends StatefulWidget {
  static const routeName = "rating-screen";
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0;
  TextEditingController notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    final double circleRadius = 80.0;
    final double circleBorderWidth = 8.0;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: height / 1.4,
                    width: width,
                    decoration: BoxDecoration(
                        color: IconColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: circleRadius / 2.0),
                            child: Container(
                              width: width,
                              height: height / 1.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          Container(
                            width: circleRadius,
                            height: circleRadius,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/dp.jpg',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * .5 / 120,
                                ),
                                Text(
                                  "George Smith",
                                  style:
                                      TextStyle(fontSize: 17, letterSpacing: 2),
                                ),
                                SizedBox(
                                  height: height / 80,
                                ),
                                Text(
                                  "654 - UKW",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                Text(
                                  "How is your trip?",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                                SizedBox(
                                  height: height / 60,
                                ),
                                Text(
                                  "Your feedback will help",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                Text(
                                  "improving driving experience",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: height / 50,
                                ),
                                RatingBar.builder(
                                  initialRating: _rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 50.0,
                                  unratedColor: Colors.grey[300],
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating = rating;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: height / 20,
                                ),
                                Container(
                                  width: 300,
                                  child: TextFormField(
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: "Add comments",
                                      fillColor: Colors.grey.shade400,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Submit Review',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RideHistory(rating: _rating),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
