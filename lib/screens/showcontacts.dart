// import 'package:flutter/material.dart';
// import 'package:fast_contacts/fast_contacts.dart';
// import 'package:flutter_sms/flutter_sms.dart';
// import 'package:share/share.dart';

// class ShareScreen extends StatefulWidget {
//   @override
//   _ShareScreenState createState() => _ShareScreenState();
// }

// class _ShareScreenState extends State<ShareScreen> {
//   List<Contact> contacts = [];
//   String message = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Share Message'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   message = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Enter your message',
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(contacts[index].displayName ?? ''),
//                   subtitle: Text(contacts[index].phoneNumber ?? ''),
//                   onTap: () {
//                     _shareMessage(contacts[index].phoneNumber ?? '');
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _getContacts();
//         },
//         child: Icon(Icons.contacts),
//       ),
//     );
//   }

//   Future<void> _getContacts() async {
//     try {
//       List<Contact> result = await FastContacts.getAllContacts();
//       setState(() {
//         contacts = result;
//       });
//     } catch (e) {
//       // Handle error
//     }
//   }

//   void _shareMessage(String phoneNumber) {
//     if (message.isNotEmpty) {
//       String text = 'Message: $message';
//       String recipient = phoneNumber ?? '';
//       Share.share(text, subject: 'Share Message', recipient: recipient);
//     }
//   }
// }
