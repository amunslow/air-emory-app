import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:instant/instant.dart';
import 'response_widget.dart';
import 'pmStats_widget.dart';
import 'dart:math';
import 'lineChart_widget.dart';
import 'dashboard_widget.dart';

// Request to get the first and second sheet(current day, yesterday)
Future<List<Post>> fetchPost() async {
  List<String> sheet = ['1', '2'];
  List<http.Response> list = await Future.wait(sheet.map((sheet) => http.get('https://spreadsheets.google.com/feeds/list/1IpmZM0CTu4Ju2vR9nNPbUOFKtJNHCO69ydEH9vAtxWI/$sheet/public/values?alt=json')));
  return list.map((response) {
    return Post.fromJson(json.decode(response.body));
  }).toList();
}

class Post {
  Feed feed;
  Post({this.feed});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      feed: Feed.fromJson(json['feed']),
    );
  }
}

class Feed {
  List<Entry> entries;

  Feed({this.entries});

  factory Feed.fromJson(Map<String, dynamic> json) {
    var list = json['entry'] as List;
    List<Entry> entryList = list.map((i) => Entry.fromJson(i)).toList();
    return Feed(
      entries: entryList,
    );
  }
}

class Entry {
  final Value timestamp;
  final Value pmfine;
  final Value humidity;
  final Value temperature;
  
  Entry({this.timestamp, this.pmfine, this.humidity, this.temperature});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      timestamp: Value.fromJson(json['gsx\$timestamp']),
      pmfine: Value.fromJson(json['gsx\$pmfine']),
      humidity: Value.fromJson(json['gsx\$relativehumidity']),
      temperature: Value.fromJson(json['gsx\$temperaturec']),
    );
  }
}

class Value {
  String t;
  Value({this.t});

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      t: json['\$t'],
    );
  }
}

class PMAvg  {
   double avg;
   double total;
   int numEntries;
   PMAvg(this.avg, this.total, this.numEntries);
  
  //return PMAvg(this.avg, this.total, this.numEntries);
  /*
  @override
  Widget build(BuildContext context) {

    return PMAvg(avg, total, numEntries);
  }
  */
}

Material aqiTile(int aqi) {
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child:Center(
      child: Padding(
        padding:const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Aqi',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize:10.0
                )
              ),
              Text(aqi.toString(),
              style:TextStyle(
                color: Colors.blue,
                fontSize:20.0,
              ))
            ]
          )
        ],
      ))
  ));
}

// Function to get the last data entry and its list index
ResponseWidget lastEntry(List<Entry> entryList) {
  var timestamp = DateFormat('yyyy-MM-dd').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4)));
  int i;
  for (i = entryList.length-1; i >= 0; i--) {
    if (timestamp == entryList[i].timestamp.t.substring(0,10)) {
      return ResponseWidget(entryList[i].timestamp.t, entryList[i].temperature.t, entryList[i].humidity.t, entryList[i].pmfine.t);
    }
  }
  return ResponseWidget('No Data', 'No Data', 'No Data', 'No Data');
}

// Function to tell if the sheet contains current day and yesterday data
int currAndYestData(List<Entry> entryList) {
  var currTime = DateFormat('yyyy-MM-dd').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4)));
  var yestTime = DateFormat('yyyy-MM-dd').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4, days:1)));
  int curr = 0;
  int yest = 0;
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].timestamp.t.substring(0,10) == currTime) curr = 1;
    if (entryList[i].timestamp.t.substring(0,10) == yestTime) yest = 1;
  }

  if (curr == 1 && yest == 1) {
    return 1;
  }
  return 0;
}

// Function to get the timestamp 12 hours before the current time
String get12HrTimestamp() {
  var timestamp = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:16)));
  print('12 hr timestamp: ' + timestamp);
  return timestamp;
}

// Function to get the total PM2.5 from a List<Entry> using the timestamp 12 hours before the last data entry
PMStats getTotalPm(List<Entry> entryList) {
  List<PMAvg> total = new List<PMAvg>();
  PMAvg p = PMAvg(0.0, 0.0, 0);
  for (int j = 0; j < 13; j++) {
    total.add(p);
  }
  double max = 0.0;
  double min = 10000000.0;
  int index;
  String timepast = get12HrTimestamp();
  int hour24 = int.parse(timepast.substring(11,13));
  int min24 = int.parse(timepast.substring(14, 16));
  String date24 = timepast.substring(0,10);
  String currTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4)));
  int currhour = int.parse(currTime.substring(11,13));
  print('currhour: ' + currhour.toString());
  print('date 12: ' + date24);
  String currdate = currTime.substring(0,10);
  print('currdate: ' + currdate);
  for (int i = entryList.length-1; i >= 0; i--) {
    String entryTime = entryList[i].timestamp.t;
    int entryhour = int.parse(entryTime.substring(11,13));
    int entrymin = int.parse(entryTime.substring(14,16));
    String entrydate = entryTime.substring(0,10);
    if ((currdate != date24 && entrydate == date24 && entryhour >= hour24) || (currdate != date24 && entrydate == currdate && entryhour <= currhour) || (currdate == date24 && entrydate == currdate && entryhour >= hour24 && entryhour <= currhour)) {
      if (entryhour == hour24 && entrymin < min24) {
        print(hour24.toString()+':'+min24.toString()+' is over the 12 hours');
        continue;
      }
      if (hour24 == 0) {
        index = entryhour;
      } else {
        index = entryhour % hour24;
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
int getAqi(int currAndYestData, List<Entry> currList, List<Entry> yestList) {
  PMStats totpm;
  double range, scaledRateOfChange, weightFactor, sum, denomSum, nowCast;
  int power, aqi;
  sum = 0.0;
  denomSum = 0.0;
  if (currAndYestData == 1) {
    totpm = getTotalPm(currList);
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
    PMStats currStats = getTotalPm(currList);
    PMStats yestStats = getTotalPm(yestList);
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

class ReportWidget extends StatefulWidget {
  ReportWidget({Key key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportWidget> {
  Future<List<Post>> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: FutureBuilder(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                  //return ListView.builder(
                    //itemCount: 1,
                    //itemBuilder: (context, index) {
                      Post curr = snapshot.data[0];
                      Post yest = snapshot.data[1];
                      if (curr.feed.entries.length == 0 || curr.feed.entries == null) {
                        return Column(children: <Widget>[
                        //Text('Air Quality Report', textAlign: TextAlign.center, style: TextStyle(fontSize: 28)),
                        //Text('generated at ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4))) + " EST", textAlign: TextAlign.center, style:  TextStyle(fontSize: 15)),
                        Text('No Data', textAlign: TextAlign.center, style: TextStyle(fontSize: 25))
                      ],);
                      } else {
                        
                        ResponseWidget lastent = lastEntry(curr.feed.entries);
                        int cydata = currAndYestData(curr.feed.entries);
                        int aqi = getAqi(cydata, curr.feed.entries, yest.feed.entries);
                        LineChartSample2 lineChart = LineChartSample2(entries:curr.feed.entries);
                        return Dashboard(aqi:aqi, lastEntry: lastent, lineChart: lineChart);
                        //return Column(children:<Widget>[)]);


                        /*
                        return Column(children: <Widget>[
                          Text('Air Quality Report', textAlign: TextAlign.center, style: TextStyle(fontSize: 28)),
                          Text('generated at ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeToZone(zone: "UTC", datetime: DateTime.now()).subtract(Duration(hours:4))) + " EST", textAlign: TextAlign.center, style:  TextStyle(fontSize: 15)),
                          //lastent,
                          aqiTile(aqi),
                          //Text('AQI: ' + aqi.toString(),  style: TextStyle(fontSize: 20),),
                          //SimpleLineChart.withSampleData(),
                          LineChartSample2(entries: curr.feed.entries),
                        ],);*/
                      }
                   // }                  
                 // );
              } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          //),
        ),
      ));
  }
}



