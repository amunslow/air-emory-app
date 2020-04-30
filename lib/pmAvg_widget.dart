import 'package:flutter/material.dart';

class PMAvg extends StatelessWidget {
  double avg;
  double total;
  int numEntries;
  
  PMAvg(this.avg, this.total, this.numEntries);

  @override
  Widget build(BuildContext context) {

    return PMAvg(avg, total, numEntries);
  }
}