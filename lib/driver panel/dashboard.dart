// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_driver_app/screens/ridehistory.dart';

import '../widgets/myColors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageIcon(
                AssetImage("assets/images/menu.png"),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        backgroundColor: IconColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: circleRadius / 2.0),
                          child: Container(
                            width: width - 20,
                            height: height,
                            decoration: BoxDecoration(
                                color: IconColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: width,
                              height: height / 1.3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
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
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30.0,
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
                              Container(
                                height: height / 3,
                                width: width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.circle_outlined,
                                              color: IconColor,
                                              size: 20,
                                            ),
                                            trailing: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: RatingBar.builder(
                                                initialRating: _rating,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                unratedColor: Colors.grey[300],
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  setState(() {
                                                    _rating = rating;
                                                  });
                                                },
                                              ),
                                            ),
                                            title: Text("Driver Rating"),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.circle_outlined,
                                              color: IconColor,
                                              size: 20,
                                            ),
                                            trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text("150")),
                                            title: Text("Rides "),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.circle_outlined,
                                              color: IconColor,
                                              size: 20,
                                            ),
                                            trailing: Text("\$ 1400"),
                                            title: Text("Earning"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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

class progressTile extends StatefulWidget {
  const progressTile({
    super.key,
  });

  @override
  State<progressTile> createState() => _progressTileState();
}

class _progressTileState extends State<progressTile> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(
            Icons.circle_outlined,
            color: IconColor,
            size: 20,
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0,
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
          ),
          title: Text("Driver Rating"),
        ),
      ),
    );
  }
}
