import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';


class PinData {
  String pinPath; //path to pin image 
  String avatarPath; //path to image for the pin location 
  String locationName;
  String pmStats;
  String description;
  DateTime timeStamp;
  LatLng locationCoords;
  Color labelColor;


  PinData(
      {
      this.pinPath,
      this.avatarPath,
      this.locationName,
      this.pmStats,
      this.description,
      this.timeStamp,
      this.locationCoords,
      this.labelColor
      });
}


/*
final List<Sensor> sensorList = [
  Sensor(
      pinPath: ,
      locationName: 'MSC',
      pmStats: 'hi',
      description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
      locationCoords: LatLng(33.7902108,-84.3287008),
      timeStamp: DateTime.now(), 

      )
  
];

*/

//Sensor(
  //  locationName: 'Andrews Coffee Shop',
  //    pmStats: 1,
  //    description:
  //        'All-day American comfort eats in a basic diner-style setting',
  //    locationCoords: LatLng(40.751908, -73.989804),
  //    timeStamp: DateTime.now()
  //    ),