import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'response_widget.dart';
import 'lineChart_widget.dart';

class Dashboard extends StatefulWidget {
  final int aqi;
  final ResponseWidget lastEntry;
  final LineChartSample2 lineChart;
  Dashboard({Key key, @required this.aqi, @required this.lastEntry, @required this.lineChart}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Material aqiTile(int aqi) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
    child:Center(
      child: Padding(
        padding:const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Aqi',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize:18.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Text(aqi.toString(),
                style: TextStyle(
                color: Colors.blue,
                fontSize:35.0,
              )))
            ]
          )
        ],
      ))
  ));
}

Material lastEntryTile(ResponseWidget lastEntry) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding:const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Last Data Entry',
              textAlign: TextAlign.center,
                style: 
                  TextStyle(
                    color: Colors.blueGrey,
                    fontSize:18.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                'Timestamp: ' + lastEntry.timestamp,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:15.0
                )
              ),
              Text(
                'PM\u2082\u002e\u2085: ' + (double.parse(lastEntry.pmfine)).toStringAsFixed(2) + '\u03BCg/m\u00B3',
                textAlign: TextAlign.left,
                style:TextStyle(
                  color: Colors.blue,
                  fontSize:15.0,
                )),
              Text(
                'Temperature: ' + (double.parse(lastEntry.temperature)).toStringAsFixed(2) + '\u2103',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:15.0
                )
              ),
              Text(
                'Relative Humidity: ' + (double.parse(lastEntry.humidity)).toStringAsFixed(2) + '%',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:15.0
                )
              ),
            ]
          )
        ])
  ));
}

  Material pmChartTile(LineChartSample2 lineChart) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
    child:Center(
      child: lineChart,
    )
      );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Air Quality Report')),
      body: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                //Expanded(child: Container()),
                aqiTile(widget.aqi), //aqi 
                aqiTile(2), //aqi indicator
                aqiTile(3), //aqi tips
                lastEntryTile(widget.lastEntry), //last data entry
                aqiTile(5), //daily averages
                pmChartTile(widget.lineChart), //pm2.5 line chart
              ],
              staggeredTiles: [
                StaggeredTile.extent(1, 200.0),
                StaggeredTile.extent(1, 200.0),
                StaggeredTile.extent(2, 240.0),
                StaggeredTile.extent(2, 130.0),
                StaggeredTile.extent(2, 130.0),
                StaggeredTile.extent(2, 340.0)
              ],
            ));
  }

}
