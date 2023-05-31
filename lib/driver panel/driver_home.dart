import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_driver_app/auth/auth_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  @override
  void initState() {
    super.initState();
    requestPermission();

    _messaging = FirebaseMessaging.instance;
    
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Configure the notification channels.
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'news',
      'News notifications',
      description: 'Notifications about new news articles',
      importance: Importance.max,
    );
    
    // Subscribe to topic notifications.
    _messaging.subscribeToTopic('news');

    // Configure the message callback functions.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages.
      print(message.data);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{
      // Handle incoming messages in the background.
      print(message.data);
    });
    flutterLocalNotificationsPlugin
      .initialize(
        InitializationSettings(
          android: AndroidInitializationSettings(channel.id),
        ),
      )
      .then((_) {
        // Configure the notification settings.
        FirebaseMessaging.onMessageOpenedApp.listen((notification) {
            // Handle notification tapped.
            print(notification.messageId);
            print(notification.data);
           // flutterLocalNotificationsPlugin.show(int.parse(notification.messageId as String), notification.category, notification.senderId, NotificationDetails());
          });
      });

      
  }

  @override
  Widget build(BuildContext context) {
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
      }, child: const Text("ghgoooooooooooo")),
      ElevatedButton(onPressed: (){
      requestPermission();
      FirebaseMessaging.instance.getToken().then((token) {
      print('Device FCM token: $token');
    });
      }, child: const Text("toooooooken"))
      
      ]),
    );
  }
}