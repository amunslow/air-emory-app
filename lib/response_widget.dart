import 'package:flutter/material.dart';

class ResponseWidget extends StatelessWidget {
  final String timestamp;
  final String temperature;
  final String humidity;
  final String pmfine;
  final int i;

  ResponseWidget(this.timestamp, this.temperature, this.humidity, this.pmfine, this.i);

  @override
  Widget build(BuildContext context) {

    return Text('Timestamp: ' + timestamp + ' EST'
                              '\nPM\u2082\u002e\u2085: ' + pmfine + '\u03BCg/m\u00B3' +
                              '\nTemperature: ' + temperature + '\u2103' + 
                              '\nRelative Humidity: ' + humidity + '%',
                              style: TextStyle(fontSize: 20),
    );

  }
}