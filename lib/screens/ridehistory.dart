// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../widgets/myColors.dart';

class RideHistory extends StatelessWidget {
  const RideHistory({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    final double circleRadius = 80.0;
    final double circleBorderWidth = 8.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
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
              const AssetImage("assets/images/menu.png"),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Transactions History",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: height / 1.8,
              width: width,
              decoration: BoxDecoration(
                  color: IconColor, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: circleRadius / 2.0),
                      child: Container(
                        width: width,
                        height: height / 3,
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
                            style: TextStyle(fontSize: 17, letterSpacing: 2),
                          ),
                          Text(
                            "654 - UKW",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          RatingBarIndicator(
                            rating: rating,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          Container(
                            height: 150,
                            width: width / 1.4,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "assets/images/history.png"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "7958 swift Village",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text("105 Willaim St,Chicago",
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/images/cardlogo.png')),
                                          ),
                                          Text(
                                            "\$75.00",
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      )
                                    ],
                                  )
                                ],
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
            SizedBox(
              height: height / 10,
            ),
            Center(
              child: Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {},
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
