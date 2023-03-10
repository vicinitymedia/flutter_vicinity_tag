library vicinity_location_tags;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';

class VicinityLocationTags {

  String? _currentAddress;
  Position? _currentPosition;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<dynamic> initUserAgentState(int zoneId) async {
    String userAgent, webViewUserAgent;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final url = Uri.parse('https://leo.vic-m.co/api/mobile-tags');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent!;
      Position? location = await _getCurrentPosition();
      if (location != null) {
        String? address = await _getAddressFromLatLng(location);
        if (address != null) {
          Map<String, dynamic> data = {
            "user_agent": "$userAgent $webViewUserAgent",
            "latitude" : location!.latitude,
            "longitude": location!.longitude,
            "address": address,
            "appName":appName,
            "packageName":packageName,
            "version":version,
            "buildNumber":buildNumber,
            "zoneId": zoneId
          };
          final response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(data),
          );
          if (response.statusCode == 200) {
            // Request successful, handle response
            print(response.body);
          } else {
            // Request failed, handle error
            print(response.statusCode);
          }
          // print("Address is $address");
          // return data;
        } else {
          Map<String, dynamic> data = {
            "user_agent": "$userAgent $webViewUserAgent",
            "latitude" : location!.latitude,
            "longitude": location!.longitude,
            "address": null,
            "appName":appName,
            "packageName":packageName,
            "version":version,
            "buildNumber":buildNumber,
            "zoneId": zoneId
          };
          final response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(data),
          );
          if (response.statusCode == 200) {
            // Request successful, handle response
            print(response.body);
          } else {
            // Request failed, handle error
            print(response.statusCode);
          }
          // print("no address");
          // return data;
        }
      } else {
        Map<String, dynamic> data = {
          "user_agent": "$userAgent $webViewUserAgent",
          "latitude" :null,
          "longitude": null,
          "address": null,
          "appName":appName,
          "packageName":packageName,
          "version":version,
          "buildNumber":buildNumber,
          "zoneId": zoneId
        };
        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          // Request successful, handle response
          print(response.body);
        } else {
          // Request failed, handle error
          print(response.statusCode);
        }
      }
    
    } on PlatformException {
      // userAgent = webViewUserAgent = '<error>';
      return [];
    }
  }

  Future<Position?> _getCurrentPosition() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return _currentPosition;
  }

  Future<String?> _getAddressFromLatLng(Position position) async {


    List<Placemark>? placemarks= await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude);
    if(placemarks!.isNotEmpty){
      Placemark place = placemarks[0];
      String addre =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      return addre;
    }
    else{
      return 'xcv';
    }

  }
}
