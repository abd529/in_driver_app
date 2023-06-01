import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  late FirebaseMessaging _messaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void requestPermission()async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(alert: true, announcement:false,badge:true, carPlay: false, criticalAlert: false, provisional: false,sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {print('User granted permission');

} else if (settings.authorizationStatus == AuthorizationStatus.provisional) { print('User granted provisional permission');

} else {
  print('User declined or has not accepted permission');
}
   print("permission okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=key=AAAANKVW1Kg:APA91bE2tuK90I3kgjHGnx-DWn_IiorJvAww7PwyqdwCg8_WiZWbENI7gqNZDpJCh66HbydWpPWh9OSwhDaH9C4D3iLoWhy3X-QSe-lGsQKVdehI6DDbQp7fY_hmKdwZtK2dzqAkAllj',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'token':token
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();

    _messaging = FirebaseMessaging.instance;
    
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Configure the notification channels.
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'news',
    //   'News notifications',
    //   description: 'Notifications about new news articles',
    //   importance: Importance.max,
    // );
    
    // Subscribe to topic notifications.
    _messaging.subscribeToTopic('news');

    // Configure the message callback functions.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages.
      print(message.data);
    });
    AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
  null,
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white)
  ],
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group')
  ],
  debug: true
);
  // AwesomeNotifications().setListeners(onActionReceivedMethod:(receivedAction) async{
  //     //return NotificationController.onActionReceivedMethod(receivedAction, context, userEM);
  //   print("listened");
    
  //   });

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{
    //   // Handle incoming messages in the background.
    //   print(message.data);
    // });
    // flutterLocalNotificationsPlugin
    //   .initialize(
    //     InitializationSettings(
    //       android: AndroidInitializationSettings(channel.id),
    //     ),
    //   )
    //   .then((_) {
    //     // Configure the notification settings.
    //     FirebaseMessaging.onMessageOpenedApp.listen((notification) {
    //         // Handle notification tapped.
    //         print(notification.messageId);
    //         print(notification.data);
    //        // flutterLocalNotificationsPlugin.show(int.parse(notification.messageId as String), notification.category, notification.senderId, NotificationDetails());
    //       });
    //   });

      
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
          .addPostFrameCallback((_) => 
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          myBackgroundMessageHandler(message);
          }));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          const Text("Driver Panel"),
          ElevatedButton(onPressed: (){
                 FirebaseAuth.instance.signOut();
                 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (ctx) => AuthHome()),
                                (Route<dynamic> route) => false);
      }, child: const Text("log out")),
      ElevatedButton(onPressed: (){
      //requestPermission();
      FirebaseMessaging.instance.getToken().then((token) {
      print('Device FCM token: $token');
    });
      }, child: const Text("toooooooken")),
      ElevatedButton(onPressed: (){
        sendPushMessage("This is body","title","eWEE_ZnFTz6IRzjN3fgjI7:APA91bEDZsvdC-0ldxBvzAJy5s0dfxBO4GsMN2ZqmEKiIlKIOC4nTw3Vgy4fm2TxKicNItDjLtptmSUTSIQXbBIkIpWwYZkBrakjgm9yUjjluGZLV7ApXm-Xd20CXkoW-X2frl16v0gz");
      }, child: const Text("send ride request"))
      
      ]),
    );
  }
}
