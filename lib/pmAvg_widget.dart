import 'package:flutter/material.dart';

class PMAvg extends StatelessWidget {
  final double avg;
  final double total;
  final int numEntries;
  
  PMAvg(double avg, double total, int numEntries);

  @override
  Widget build(BuildContext context) {

    return PMAvg(avg, total, numEntries);
  }
}