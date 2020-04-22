import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Sensor {
  String locationName;
  double pmStats;
  String description;
  DateTime dateTime;
  LatLng locationCoords;

  Sensor(
      {this.locationName,
      this.pmStats,
      this.description,
      this.dateTime,
      this.locationCoords});
}

final List<Sensor> sensorList = [
  Sensor(
      locationName: 'Stumptown Coffee Roasters',
      pmStats: 1,
      description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
      locationCoords: LatLng(40.745803, -73.988213),
      dateTime: DateTime.now()
      ),
  Sensor(
    locationName: 'Andrews Coffee Shop',
      pmStats: 1,
      description:
          'All-day American comfort eats in a basic diner-style setting',
      locationCoords: LatLng(40.751908, -73.989804),
      dateTime: DateTime.now()
      ),
  Sensor(
      locationName: 'Third Rail Coffee',
      pmStats: 1,
      description:
          'Small spot draws serious caffeine lovers with wide selection of brews & baked goods.',
      locationCoords: LatLng(40.730148, -73.999639),
      dateTime: DateTime.now()
      ),
  Sensor(
      locationName: 'Hi-Collar',
      pmStats: 1,
      description:
          'Snazzy, compact Japanese cafe showcasing high-end coffee & sandwiches, plus sake & beer at night.',
      locationCoords: LatLng(40.729515, -73.985927),
      dateTime: DateTime.now()
      ),
  Sensor(
      locationName: 'Everyman Espresso',
      pmStats: 1,
      description:
          'Compact coffee & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
      locationCoords: LatLng(40.721622, -74.004308),
      dateTime: DateTime.now()
      )
];
