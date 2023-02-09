library vicinity_location_tags;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';
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
    // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

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

          Map data = {
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
          print("Address is $address");
          return data;
        } else {
          Map data = {
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
          print("no address");
          return data;
        }
      } else {
        Map data = {
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
        print("no location ");
        return data;
      }
      // print('''
      //     applicationVersion => ${FlutterUserAgent.getProperty('applicationVersion')}
      //     systemName         => ${FlutterUserAgent.getProperty('systemName')}
      //     userAgent          => $userAgent
      //     webViewUserAgent   => $webViewUserAgent
      //     packageUserAgent   => ${FlutterUserAgent.getProperty('packageUserAgent')}
      //      ''');
      //  Map data = {"user_agent": "$userAgent $webViewUserAgent"};
      // location['user_agent']= "$userAgent $webViewUserAgent";
      // data.addAll(location);
      // print(location);
      // return location;
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
