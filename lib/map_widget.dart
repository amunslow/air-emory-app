import 'package:airemory/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


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



class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> {
 GoogleMapController _controller;
 Future<List<Post>> post;
 List<Marker> allMarkers = [];

 
 BitmapDescriptor _sourceIcon;
 //BitmapDescriptor _yellowIcon;
 //BitmapDescriptor _sourceIcon;


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

/*
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
*/
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
          icon: _sourceIcon,
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
    _getCurrentLocation();
    _setSourceIcon();
    super.initState();
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
    _firstPinInfo = PinData(
        pinPath: 'assets/pin.png',
        pmStats: '15',
        description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
        locationName: "MSC",
        timeStamp: DateTime.now(), 
        locationCoords: LatLng(33.7902108,-84.3287008),
        avatarPath: "assets/flower.jpeg",
        labelColor: Colors.blue);

    _secondPinInfo = PinData(
        pinPath: 'assets/pin.png',
        pmStats: '13',
        description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
        locationName: "Other",
        timeStamp: DateTime.now(), 
        locationCoords: LatLng(33.7902108,-84.4287008),
        avatarPath: "assets/flower.jpeg",
        labelColor: Colors.blue);
      
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            )
            
          ],

        ),
      ),
    );
  }

    
    

}