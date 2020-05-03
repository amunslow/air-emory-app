import 'package:airemory/faq1_widget.dart';
import 'package:flutter/material.dart';
import 'map_widget.dart';
import 'placeholder_widget.dart';
import 'report_widget.dart';
import 'package:airemory/faq_widget';

class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [ // list of our final widgets (pages)
   MapWidget(),
   ReportWidget(),
   FAQtwo()
 ];

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     
    /* appBar: AppBar(
       title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset(
                 'assets/cloud.png',
                  fit: BoxFit.contain,
                  height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Air Emory'))
            ],

          ),
     ),*/
   
    body: _children[_currentIndex],
     bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, 
       currentIndex: _currentIndex,
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.map),
           title: new Text('Map'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.library_books),
           title: new Text('Report'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.question_answer),
           title: Text('FAQ')
         )
       ],
     ),
   );
 }

 void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
}