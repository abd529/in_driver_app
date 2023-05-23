import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        "Failed, No Response";
      }
    } catch (e) {
      print("Failed");
    }
  }
}
