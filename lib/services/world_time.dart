import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Worldtime {
  String? location; // Location name
  String? time; // Time in the location
  String? flag; // URL to an asset file location
  String? url; // Location URI for API endpoint
  bool? isDaytime; //

  Worldtime({this.location, this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // Make the request
      final response = await http
          .get(Uri.parse("http://worldtimeapi.org/api/timezone/$url"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Getting properties from data
        String datetime = data['datetime'];
        String offset = data['utc_offset'].substring(1, 3);

        // Create a DateTime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));

        //setting time property
        isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
      time = 'Could not get time';
    }
  }
}
