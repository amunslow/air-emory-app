import 'package:airemory/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'helpers/map_helper.dart';
//import 'helpers/map_marker.dart';



class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> {

 List<Marker> allMarkers = [];

 GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    sensorList.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.locationName),
          draggable: false,
          onTap: () {
          print('Marker Tapped');
        },
          infoWindow:
              InfoWindow(title: element.locationName, snippet: element.description),
    
          position: element.locationCoords));
    });
    
  }



  
/*
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
  ];





  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }
 
  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          infoWindow: InfoWindow(
                title: 'PlatformMarker',
                snippet: "Hi I'm a Platform Marker",
              ),
          icon: markerImage,
          onPressed:(){
            showModalBottomSheet(
              context: context, 
              builder: (builder){
              return Container(
                color: Colors.white,
                child: Text("Hello there"),
            );
          });
         },
        ),
      );

     
      

    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  */ 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Markers'),
      ),
      body: Stack(
       children: [Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         child: GoogleMap(
           initialCameraPosition: CameraPosition(target: LatLng(40.745803, -73.988213), zoom: 12.0),
           markers: Set.from(allMarkers),
           onMapCreated: mapCreated,
         ),
       ),
       Align(
         alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: movetoAtlanta,
            child: Container(
              height:40.0, 
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.green
              ),
              child: Icon(Icons.forward, color: Colors.white),
            ),
          )
        )
       ]
      ),
    );
  }

  void mapCreated(controller){
    setState(() {
      controller = controller;
    });
  }

  movetoAtlanta(){
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.7490, -84.3880), zoom: 12.0),
    ));
  }

    
    

}