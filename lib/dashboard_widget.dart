import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'response_widget.dart';
import 'lineChart_widget.dart';

class Dashboard extends StatefulWidget {
  final int aqi;
  final ResponseWidget lastEntry;
  final ResponseWidget dailyAvg;
  final LineChartSample2 lineChart;
  final String aqiDescriptionText;
  final String timestampNow;
  Dashboard({Key key, @required this.timestampNow, @required this.aqi, @required this.aqiDescriptionText, @required this.lastEntry, @required this.dailyAvg, @required this.lineChart}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Material aqiValuesTile() {
    return Material(
    animationDuration: kThemeChangeDuration,
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
    child:Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child:  Text(
                  'AQI Values',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize:18.0,
                    fontWeight: FontWeight.bold,
                  )
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                child: Padding(
                  padding:const EdgeInsets.all(3.0),
                  child: Text('0 to 50',
                  textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize:20.0,
                )))),           
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow,
                child: Padding(
                  padding:const EdgeInsets.all(3.0),
                  child: Text('51 to 100',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize:20.0,
              )))),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.orange,
                child: Text('101 to 150',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.white,
                  fontSize:20.0,
              ))),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:const EdgeInsets.all(3.0),
                  child: Text('151 to 200',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize:20.0,
                )))),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.purple,
                child: Padding(
                  padding:const EdgeInsets.all(3.0),
                  child: Text('201 to 300',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize:20.0,
                )))),
              Container(
                width: MediaQuery.of(context).size.width,
                color:  Color.fromRGBO(128, 0, 0, 1),
                child: Padding(
                  padding:const EdgeInsets.all(3.0),
                  child: Text('301 to 500',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize:20.0,
                )))),
              Container(
                 width: MediaQuery.of(context).size.width,
                 child: Padding(
                    padding:const EdgeInsets.all(3.0),
                    child:Text('* AQI values above 500 are considered Beyond The AQI', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize:10.0,
                        fontWeight: FontWeight.bold,
                      ))
                 )
              )
              
            ]
          )),
        ],
      )
  ));
  }

  Material aqiDescriptionTile() {
    return Material(
      animationDuration: kThemeChangeDuration,
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
            Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'AQI Level',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize:18.0,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Text(widget.aqiDescriptionText,
                  style: TextStyle(
                  color: aqiColor(widget.aqiDescriptionText),
                  fontSize:40.0,
                ))),
                Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: Text(aqiTips(widget.aqiDescriptionText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                ))))
              ]
            ))
          ],
        ))
    ));
  }

  Material aqiTile(int aqi) {
  return Material(
    animationDuration: kThemeChangeDuration,
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
                'AQI',
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
                fontSize:50.0,
              )))
            ]
          )
        ],
      ))
  ));
}

// Function to try to parse the double, return No data if unsuccessful
// Value = the value of the field
// Field = pmfine, temp, or rh 
String parseValue(String value, String field) {
  double val = double.tryParse(value);
  if (val == null) { 
    if (field == "pmfine") {
      //return 'PM\u2082\u002e\u2085: No Data';
      return 'No Data';
   } else if (field == "temp") {
      //return 'Temperature: No Data';
      return 'No Data';
    } else if (field == "rh") {
      //return 'Relative Humidity: No Data';
      return 'No Data';
    }
  } else {
    if (field == "pmfine") {
      //return 'PM\u2082\u002e\u2085: ' + val.toStringAsFixed(2) + '\u03BCg/m\u00B3';
      return val.toStringAsFixed(2) + '\u03BCg/m\u00B3';
    } else if (field == "temp") {
     // return 'Temperature: ' + val.toStringAsFixed(2) + '\u2103';
     return val.toStringAsFixed(2) + '\u2103';
    } else if (field == "rh") {
      //return 'Relative Humidity: ' + val.toStringAsFixed(2) + '%';
      return val.toStringAsFixed(2) + '%';
    }
  }
  return 'No Data';
}

// Function to return health tips for the specific AQI level 
// level = the aqi level (good, moderate, etc.)
String aqiTips(String level) {
  if (level == "Good") {
    return "Exercise and play outside to your heart’s content! The air poses no risk today.";
  } else if (level == "Moderate") {
    return "For most people, the air poses no risk! Enjoy any outdoor activity! People who are very sensitive to ozone and other specific pollutants may want to avoid excessive outdoor activity to avoid respiratory symptoms.";
  } else if (level == "Unhealthy for Sensitive Groups") {
    return "For most people, the air poses no risk! Enjoy any outdoor activity! However, people with respiratory disease, heart disease, people with any other specific sensitivity, and children and adults who spend a lot of time outdoors should avoid going outside when it is unnecessary to do so.";
  } else if (level == "Unhealthy") {
    return "Everyone should limit outdoor activity today. Try to exercise or play inside! People with sensitivities, such as respiratory disease or heart disease, are likely to experience even worse symptoms and should take special care to limit their time outside.";
  } else if (level == "Very Unhealthy") {
    return "Everyone should avoid outdoor activity today. Do not exercise or play outside! Everyone is at risk to experience negative respiratory symptoms, and sensitive groups, such as those with respiratory or heart disease, should stay inside.";
  } else {
    return "This is considered emergency conditions. The entire population is likely to be negatively affected and everyone should stay inside as much as possible.";
  }
}

// Function to change the color of the AQI level 
Color aqiColor(String level) {
  if (level == "Good") {
    return Colors.green;
  } else if (level == "Moderate") {
    return Colors.yellow;
  } else if (level == "Unhealthy for Sensitive Groups") {
    return Colors.orange;
  } else if (level == "Unhealthy") {
    return Colors.red;
  } else if (level == "Very Unhealthy") {
    return Colors.purple;
  } else {
    return Color.fromRGBO(128, 0, 0, 1);
  }
}

Material lastEntryTile(ResponseWidget lastEntry) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding:const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
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
                lastEntry.timestamp,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0
                )
              ),
              Expanded(child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'PM\u2082\u002e\u2085',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(lastEntry.pmfine, "pmfine"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'Temperature',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(lastEntry.temperature, "temp"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'Relative Humidity',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(lastEntry.humidity, "rh"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            ]
        )
  )])));
}

Material dailyAvgTile(ResponseWidget dailyAvg) {
  /*
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
              Text('Today\'s Averages',
              textAlign: TextAlign.center,
                style: 
                  TextStyle(
                    color: Colors.blueGrey,
                    fontSize:18.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                parseValue(dailyAvg.pmfine, "pmfine"),
                textAlign: TextAlign.left,
                style:TextStyle(
                  color: Colors.blue,
                  fontSize:15.0,
                )),
              Text(
                parseValue(dailyAvg.temperature, "temp"),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:15.0
                )
              ),
              Text(
                parseValue(dailyAvg.humidity, "rh"),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:15.0
                )
              ),
            ]
          )
        ])
  ));*/
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding:const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              Text('Today\'s Averages',
              textAlign: TextAlign.center,
                style: 
                  TextStyle(
                    color: Colors.blueGrey,
                    fontSize:18.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Expanded(child:
              Padding(padding: EdgeInsets.only(top:5.0), child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'PM\u2082\u002e\u2085',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(dailyAvg.pmfine, "pmfine"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'Temperature',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(dailyAvg.temperature, "temp"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child:  Column(children: <Widget>[
              Text(
                'Relative Humidity',
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blueGrey,
                  fontSize:15.0,
                )),
                Text(
                parseValue(dailyAvg.humidity, "rh"),
                textAlign: TextAlign.center,
                style:TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize:18.0,
                )),
            
            ])
            ),
            ]
        ))
  )])));
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
      /*appBar: AppBar(title: Text('Air Quality Report')),*/
      body: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                Text('Air Quality Report', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold)),
                Text('generated at ' + widget.timestampNow + ' EST', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.blue)),
                aqiTile(widget.aqi), //aqi 
                aqiValuesTile(), //aqi indicator
                aqiDescriptionTile(), //aqi tips
                lastEntryTile(widget.lastEntry), //last data entry
                dailyAvgTile(widget.dailyAvg), //daily averages
                pmChartTile(widget.lineChart), //pm2.5 line chart
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 30.0),
                StaggeredTile.extent(2, 20.0),
                StaggeredTile.extent(1, 240.0),
                StaggeredTile.extent(1, 240.0),
                StaggeredTile.extent(2, 240.0),
                StaggeredTile.extent(2, 130.0),
                StaggeredTile.extent(2, 130.0),
                StaggeredTile.extent(2, 340.0)
              ],
            ));
  }

}
