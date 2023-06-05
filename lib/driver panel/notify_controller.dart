import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/driver%20panel/ride_status.dart';

import '../main.dart';

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction message, BuildContext context) async {
   if(message.buttonKeyPressed.startsWith("accept")){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RideStatus(amount:message.title as String)
            ));
        print("Accepteddddddddd");
      }else if(message.buttonKeyPressed == "decline"){
        print("declineddddddddd");
      }
    }
    
}