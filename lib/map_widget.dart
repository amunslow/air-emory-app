import 'dart:math';

import 'package:airemory/pmStats_widget.dart';
import 'package:airemory/report_widget.dart';
import 'package:airemory/response_widget.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';



import 'package:intl/intl.dart';
import 'package:instant/instant.dart';
import 'response_widget.dart';
import 'pmStats_widget.dart';



//import 'helpers/map_helper.dart';
//import 'helpers/map_marker.dart';

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




// Request to get the first and second sheet(current day, yesterday)






class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> {
 GoogleMapController _controller;
 Future<List<Post>> post;
 List<Marker> allMarkers = [];

 Post curr; //list of the data for the current day
 Post yest; //list of the data for yesterday
 String timestampNow; //timestamp for the current time
 String timestampYest; //timestamp for 24 hours before the current time
 String timestamp12Hr; //timestamp for 12 hours before the current time
 ResponseWidget lastent; //last data entry for today
 int aqi; //the aqi based on the last 12 hours of data
 int thereIsData = 0; //0 or 1, to tell if there is data for the current day

 BitmapDescriptor _sourceIcon;
 BitmapDescriptor _yellowIcon;
 BitmapDescriptor _orangeIcon;
 BitmapDescriptor _maroonIcon;
 BitmapDescriptor _greenIcon;
 BitmapDescriptor _purpleIcon;
 BitmapDescriptor _redIcon;

 // Function to get the last data entry and its list index
ResponseWidget lastEntry(List<Entry> entryList, String timestamp) {
  int i;
  for (i = entryList.length-1; i >= 0; i--) {
    if (timestamp.substring(0,10) == entryList[i].timestamp.t.substring(0,10)) {
      thereIsData = 1;
      return ResponseWidget(entryList[i].timestamp.t, entryList[i].temperature.t, entryList[i].humidity.t, entryList[i].pmfine.t);
    }
  }
  return ResponseWidget('No Data', 'No Data', 'No Data', 'No Data');
}

// Function to tell if the sheet contains current day and yesterday data
int currAndYestData(List<Entry> entryList, String currTime, String yestTime) {
  int curr = 0;
  int yest = 0;
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].timestamp.t.substring(0,10) == currTime.substring(0,10)) curr = 1;
    if (entryList[i].timestamp.t.substring(0,10) == yestTime.substring(0,10)) yest = 1;
  }

  if (curr == 1 && yest == 1) {
    return 1;
  }
  return 0;
}

// Function to get the total PM2.5 from a List<Entry> using the timestamp 12 hours before the last data entry
PMStats getTotalPm(List<Entry> entryList, String currTime, String timepast) {
  List<PMAvg> total = new List<PMAvg>();
  PMAvg p = PMAvg(0.0, 0.0, 0);
  for (int j = 0; j < 13; j++) {
    total.add(p);
  }
  double max = 0.0;
  double min = 10000000.0;
  int index;
  int hour12 = int.parse(timepast.substring(11,13));
  //int min12 = int.parse(timepast.substring(14, 16));
  String date12 = timepast.substring(0,10);
  int currhour = int.parse(currTime.substring(11,13));
  print('currhour: ' + currhour.toString());
  print('date 12: ' + date12);
  String currdate = currTime.substring(0,10);
  print('currdate: ' + currdate);
  print('hour 12: ' + hour12.toString());
  for (int i = entryList.length-1; i >= 0; i--) {
    String entryTime = entryList[i].timestamp.t;
    int entryhour = int.parse(entryTime.substring(11,13));
    //int entrymin = int.parse(entryTime.substring(14,16));
    String entrydate = entryTime.substring(0,10);
    if ((currdate != date12 && entrydate == date12 && entryhour >= hour12) || (currdate != date12 && entrydate == currdate && entryhour <= currhour) || (currdate == date12 && entrydate == currdate && entryhour >= hour12 && entryhour <= currhour)) {
      if (hour12 == 0) {
        index = entryhour;
      } else {
        index = entryhour % hour12;
      } 

      //print('entryTime: ' + entryTime + ', index: ' + index.toString());
      total[index].numEntries++;
      total[index].total += double.parse(entryList[i].pmfine.t);
      total[index].avg = total[index].numEntries / total[index].total;
      if (double.parse(entryList[i].pmfine.t) > max) {
        max = double.parse(entryList[i].pmfine.t);
      } 
      if (double.parse(entryList[i].pmfine.t) < min) {
        min = double.parse(entryList[i].pmfine.t);
      }
    }
  }
  
    return PMStats(total, max, min);
}

// The AQI equation
// https://forum.airnowtech.org/t/the-aqi-equation/169
int aqiEquation(double nowCast) {
  int aqi, aqiHi, aqiLo;
  double concLo, concHi;
  nowCast = double.parse(nowCast.toStringAsFixed(1));

  if (250.5 <= nowCast && 500.4 >= nowCast) {
    concLo = 250.5;
    concHi = 500.4;
    aqiLo = 301;
    aqiHi = 500;
  } else if (150.5 <= nowCast && 250.4 >= nowCast) {
    concLo = 150.5;
    concHi = 250.4;
    aqiLo = 201;
    aqiHi = 300;
  } else if (55.5 <= nowCast && 150.4 >= nowCast) {
    concLo = 55.5;
    concHi = 150.4;
    aqiLo = 151;
    aqiHi = 200;
  } else if (35.5 <= nowCast && 55.4 >= nowCast) {
    concLo = 35.5;
    concHi = 55.4;
    aqiLo = 101;
    aqiHi = 150;
  } else if (12.1 <= nowCast && 35.4 >= nowCast) {
    concLo = 12.1;
    concHi = 35.4;
    aqiLo = 51;
    aqiHi = 100;
  } else if (0.0 <= nowCast && 12.0 >= nowCast) {
    concLo = 0.0;
    concHi = 12.0;
    aqiLo = 0;
    aqiHi = 50;
  }

  aqi = (((aqiHi-aqiLo)/(concHi-concLo)) * (nowCast-concLo)+aqiLo).toInt();
  return aqi;
}

// Function to get the AQI
// https://forum.airnowtech.org/t/the-nowcast-for-pm2-5-and-pm10/172
int getAqi(int currAndYestData, List<Entry> currList, List<Entry> yestList, String timestampNow, String timestampYest) {
  PMStats totpm;
  double range, scaledRateOfChange, weightFactor, sum, denomSum, nowCast;
  int power, aqi;
  sum = 0.0;
  denomSum = 0.0;
  if (currAndYestData == 1) {
    totpm = getTotalPm(currList, timestampNow, timestampYest);
    range = totpm.max - totpm.min;
    scaledRateOfChange = range / totpm.max;
    weightFactor = 1 - scaledRateOfChange;
    if (scaledRateOfChange < 0.5) scaledRateOfChange = 0.5;
    for (int i = 0; i < 12; i++) {
      power = 11 - i;
      sum += totpm.total[i].avg * pow(weightFactor, power);
      denomSum += pow(weightFactor, i);
    }
  } else {
    PMStats currStats = getTotalPm(currList, timestampNow, timestampYest);
    PMStats yestStats = getTotalPm(yestList, timestampNow, timestampYest);
    double max = currStats.max;
    double min = currStats.min;
    for (int i = 0; i < 12; i++) {
      currStats.total[i].total += yestStats.total[i].total;
      currStats.total[i].numEntries += yestStats.total[i].numEntries;
      currStats.total[i].avg = currStats.total[i].total / currStats.total[i].numEntries;
    }
    if (yestStats.max > max) max = yestStats.max;
    if (yestStats.min < min) min = yestStats.min;
    range = max - min;
    scaledRateOfChange = range / max;
    weightFactor = 1 - scaledRateOfChange;
    if (scaledRateOfChange < 0.5) scaledRateOfChange = 0.5;
    for (int i = 0; i < 12; i++) {
      power = 11 - i;
      sum += currStats.total[i].avg * pow(weightFactor, power);
      denomSum += pow(weightFactor, i);
    }
  }
  nowCast = sum / denomSum;
  aqi  = aqiEquation(nowCast);
  return aqi;
}

// convert aqi number value to the aqi level
String getAqiLevel(int aqi) {
  if (aqi >= 0 && aqi <= 50) {
    return "Good";
  } else if (aqi > 50 && aqi <= 100) {
    return "Moderate";
  } else if (aqi > 101 && aqi <= 150) {
    return "Unhealthy for Sensitive Groups";
  } else if (aqi > 150 && aqi <= 200) {
    return "Unhealthy";
  } else if (aqi > 200 && aqi <= 300) {
    return "Very Unhealthy";
  } else {
    return "Hazardous";
  }
}


Widget _child = Center(
  child: Text('Loading...'),
);

 Position position;
 double _pinPillPosition = -1000;

 PinData _currentPinData = PinData(
   pinPath: '',
   avatarPath: '',
   locationName: '',
   pmStats: '',
   description: '',
   timeStamp: DateTime.now(),
   locationCoords: LatLng(0, 0),
   labelColor: Colors.grey
 );

//initializing the pin class that goes with each marker 
//used for the info window details 
 PinData _firstPinInfo;
 PinData _secondPinInfo;

void _setSourceIcon() async {
  _sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/pin.png');
  BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/green.png').then((onValue) {
      _greenIcon = onValue;
    });
  _maroonIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/maroon.png');
  _orangeIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/orange.png');
  BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/purple.png').then((onValue) {
      _purpleIcon = onValue;
    });
  _redIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/red.png');
  _yellowIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/yellow.png');
}

void _getCurrentLocation() async {
    setState(() {
      _child = _mapWidget();
    });
  }

String _getStatus(String value){
    int aqii;
    try {
      aqii = int.parse(value);
    print(aqii);
    } on FormatException {
      return 'Format error!';
    }

    if (aqii>301){
      return 'Hazardous Level';
    }
    else if (aqii>251){
      return 'Very Unhealthy Level';
    }
    else if (aqii > 151){
      return 'Unhealthy Level';
    }
    else if(aqii > 101){
      return 'Unhealthy For Sensitive Groups Level';
    }
    else if (aqii > 51){
      return 'Moderate Level';
    }
    else{
      return 'Good Level';
    }
     
  }


String _getPin(String value){
    int aqii;
    try {
      aqii = int.parse(value);
    print(aqii);
    } on FormatException {
      return 'Format error!';
    }

    if (aqii>301){
      return "assets/maroon.png";
    }
    else if (aqii>251){
      return "assets/purple.png";
    }
    else if (aqii > 151){
      return "assets/red.png";
    }
    else if(aqii > 101){
      return "assets/orange.png";
    }
    else if (aqii > 51){
      return "assets/yellow.png";
    }
    else{
      return "assets/green.png";
    }
     
  }

//the markers for each sensor 
/*
when the markers are touched(onTap()), it populates currentpindata with the pin
that is associated with that marker 
*/
Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(33.7902108,-84.3287008),
          icon: _yellowIcon,
          onTap: () {
            setState(() {
              _currentPinData = _firstPinInfo;
              _pinPillPosition = 0;
            });
          }),
      Marker(
          markerId: MarkerId('not'),
          position: LatLng(33.7902108,-84.4287008),
          icon: _sourceIcon,
          onTap: () {
            setState(() {
              _currentPinData = _secondPinInfo;
              _pinPillPosition = 0;
            });
          })
    ].toSet();
  }


  @override
  void initState() {
    
    super.initState();
    _setSourceIcon();
    _getCurrentLocation();
    post = fetchPost();
    
  }

  Widget _mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      initialCameraPosition: CameraPosition(
          target: LatLng(33.7902108,-84.3287008), zoom: 12.0),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        _setMapPins();
      },
      tiltGesturesEnabled: false,
      onTap: (LatLng location) {
        setState(() {
          _pinPillPosition = -1000;
        });
      },
    );
  }


   
// populating the pin info that we need for each marker on the info window (only)
// we will need to update this to take the aqi
  void _setMapPins() {
    int cydata = currAndYestData(curr.feed.entries, timestampNow, timestampYest);
    aqi = getAqi(cydata, curr.feed.entries, yest.feed.entries, timestampNow, timestamp12Hr);
    //String aqiDescriptionText = getAqiLevel(aqi);
    String aaqi = aqi.toString();
    _firstPinInfo = PinData(
        pinPath: _getPin(aaqi),
        pmStats: aaqi,
        description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
        locationName: "MSC",
        timeStamp: DateTime.now(), 
        locationCoords: LatLng(33.7902108,-84.3287008),
        avatarPath: "assets/flower.jpeg",
        labelColor: Colors.blue);
      
  }



  @override
  Widget build(BuildContext context) {
    
        
    return Scaffold(
      appBar: AppBar(
       title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset(
                 'assets/cloud.png',
                  fit: BoxFit.contain,
                  height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Air Emory'))
            ],

          ),
     ),
      body: Container(
          child: FutureBuilder(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                      timestampNow = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4)));
                      timestampYest = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4, days:1)));
                      timestamp12Hr = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:16)));
                      print('timestamp now: ' + timestampNow);
                      print('12 hr timestamp: ' + timestamp12Hr);
                      print('24 hr timestamp: ' + timestampYest);
                      curr = snapshot.data[0];
                      yest = snapshot.data[1];
                      lastent = lastEntry(curr.feed.entries, timestampNow);
                      if (thereIsData == 0) { //there is no data for the current day
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        //Text('Air Quality Report', textAlign: TextAlign.center, style: TextStyle(fontSize: 28)),
                        //Text('generated at ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4))) + " EST", textAlign: TextAlign.center, style:  TextStyle(fontSize: 15)),
                            Text('No Data', textAlign: TextAlign.center, style: TextStyle(fontSize: 25))
                      ],);
                      }
                      else {
                        return Stack(
                            children: <Widget>[
                              _child,
                              AnimatedPositioned(
                                bottom: _pinPillPosition,
                                right: 0,
                                left: 0,
                                duration: Duration(milliseconds: 200),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          blurRadius: 20,
                                          offset: Offset.zero,
                                          color: Colors.grey.withOpacity(0.5),
                                        )
                                      ]),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        _buildAvatar(),
                                        _buildLocationInfo(),
                                        _buildMarkerType()
                                      ]
                                    )
                                  )
                                )
                              )
                            ],
                            );
                      }
                      } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
          },
        ),
      )
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 100,
      height: 100,
      child: ClipOval(
        child: Image.asset(
          _currentPinData.avatarPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMarkerType() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Image.asset(
        _currentPinData.pinPath,
        width: 60,
        height: 60,
      ),
    );
  }
//container that displays lat and long info
  Widget _buildLocationInfo() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentPinData.locationName,
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
            Text(
              'AQI : ${_currentPinData.pmStats}',
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
            ),
            Text(
              _getStatus(_currentPinData.pmStats),
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
            ), 
            RaisedButton(
          color: Colors.blue,
          child: Text('Go to the report'),
          onPressed: () {
            //Use`Navigator` widget to pop oir go back to previous route / screen
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return Scaffold(
                  /*appBar: AppBar(title: Text('Math and Science Center Roof')),*/
                  body: Stack(
                      children: <Widget>[
                        ReportWidget(),   
                      ],
                  )
                );
              }),);
          
          },
        )
            
          ],

        ),
      ),
    );
  }

    
    

}