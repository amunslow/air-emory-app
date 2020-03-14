import 'package:airemory/report_widget.dart';
import 'package:flutter/material.dart';

class PMStats extends StatelessWidget {
  final List<PMAvg> total;
  final double max;
  final double min;

  PMStats(this.total, this.max, this.min);

  @override
  Widget build(BuildContext context) {

    return PMStats(total, max, min);
  }
}