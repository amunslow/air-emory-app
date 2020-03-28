import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'report_widget.dart';

//function to convert timestamp to number
double timestampToNumber(String timestamp) {
  int hour, min;
  if (timestamp.substring(11,12) == '0') {
    hour = int.parse(timestamp.substring(12,13));
  } else {
    hour = int.parse(timestamp.substring(11,13));
  }
  if (timestamp.substring(14,15) == '0') {
    min = int.parse(timestamp.substring(15,16));
  } else {
    min = int.parse(timestamp.substring(14,15) + timestamp.substring(15,16));
  }
  String timeNum = (((hour*60)+min)/60.0).toStringAsFixed(2);
  return double.parse(timeNum);
}

//function to convert List<Entry> to List<FlSpot>
List<FlSpot> entryToFlSpot(List<Entry> entries) {
  List<FlSpot> flSpotList = new List<FlSpot>();
  String pmfine;
  for (int i = 0; i < entries.length; i++) {
    pmfine = double.parse(entries[i].pmfine.t).toStringAsFixed(2);
    flSpotList.add(FlSpot(timestampToNumber(entries[i].timestamp.t), double.parse(pmfine)));
  }
  return flSpotList;
}

//function to get hourly avg PM2.5 from List<Entry>
List<FlSpot> getAvgPm(List<Entry> entries) {
  List<FlSpot> flSpotList = new List<FlSpot>();
  List<double> pmTot = new List<double>(24); //total pm
  List<int> pmNum = new List<int>(24); //number of entries for that hour
  for (int i = 0; i < 24; i++) {
    pmTot[i] = 0.0;
    pmNum[i] = 0;
  }

  int maxHour;
  int hour;
  for (int i = 0; i < entries.length; i++) {
    if (entries[i].timestamp.t.substring(11,12) == '0') {
    hour = int.parse(entries[i].timestamp.t.substring(12,13));
  } else {
    hour = int.parse(entries[i].timestamp.t.substring(11,13));
  }
    pmTot[hour] += double.parse(entries[i].pmfine.t);
    pmNum[hour]++;
    if (i == entries.length -1) maxHour = hour;
  }
  double avg;
  String avgString;
  for (int i = 0; i < pmTot.length; i++) {
    if (i <= maxHour) {
      if (pmNum[i] == 0 || pmTot[i] == 0) {
        flSpotList.add(FlSpot(0.0, 0.0));
      } 
      else {
        avgString = (pmTot[i]/pmNum[i]).toStringAsFixed(2);
        avg = double.parse(avgString);
        flSpotList.add(FlSpot(i / 1.0, avg));
      }
    }
  }
  return flSpotList;
}

class LineChartSample2 extends StatefulWidget {
  final List<Entry> entries;
  LineChartSample2({Key key, @required this.entries}) : super(key: key);
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(),
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
              /*
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),*/
                color: const Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: FlatButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
              TextStyle(color: const Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
              case 11:
                return '11';
              case 12:
                return '12';
              case 13:
                return '13';
              case 14:
                return '14';
              case 15:
                return '15';
              case 16:
                return '16';
              case 17:
                return '17';
              case 18:
                return '18';
              case 19:
                return '19';
              case 20:
                return '20';
              case 21:
                return '21';
              case 22:
                return '22';
              case 23:
                return '23';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt() % 10 == 0) {
              return value.toString();
            } else {
              return '';
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      axisTitleData: const FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true, 
          titleText: 'PM\u2082.\u2085 (\u03BCg/m\u00B3)', 
          margin: 10,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          margin: 0,
          titleText: 'hour',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          textAlign: TextAlign.center)
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: entryToFlSpot(widget.entries),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
              TextStyle(color: const Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
              case 11:
                return '11';
              case 12:
                return '12';
              case 13:
                return '13';
              case 14:
                return '14';
              case 15:
                return '15';
              case 16:
                return '16';
              case 17:
                return '17';
              case 18:
                return '18';
              case 19:
                return '19';
              case 20:
                return '20';
              case 21:
                return '21';
              case 22:
                return '22';
              case 23:
                return '23';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt() % 10 == 0) {
              return value.toString();
            } else {
              return '';
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      axisTitleData: const FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true, 
          titleText: 'PM\u2082.\u2085 (\u03BCg/m\u00B3)', 
          margin: 10,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          margin: 0,
          titleText: 'hour',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          textAlign: TextAlign.center)
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: getAvgPm(widget.entries),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
