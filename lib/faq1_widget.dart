import 'package:flutter/material.dart';


 class FAQtwo extends StatefulWidget {
      @override
      FAQtwoState createState() {
        return new FAQtwoState();
      }
    
 }
 class FAQtwoState extends State<FAQtwo> {
  @override
  Widget build(BuildContext context) {
    final questions = ['What is AQI?','What is PM2.5?','What causes PM2.5?', 'How does PM2.5 relate to AQI?', 'Why do you measure PM2.5 and not other sizes?','Is it possible to forecast PM2.5?', 'How might my business decrease PM2.5 emissions?','Why do we measure temperature?', 'What are the health effects for older adults?','How can I help?', 'What can I do to help improve air quality in my area?', 'How can I prevent breathing in poor air?', 'What groups are the most affected by poor air quality?' , 'What are your plans for expanding sensors to other areas?'];
    final answers = [
    'AQI as a scale that runs from 0 to 500. The higher the AQI value, the greater the level of air pollution (PM 2.5) and the greater the health concern.',
    'Particulate Matter 2.5 are tiny particles or droplets in the air that are 30 times smaller than the width of a human hair. Since they are so small, they can go deep into our lungs and circulatory system and are known to cause many chronic respitory problems such as Asthema, lung disease, and heart attacks.',
    'These particles are formed as a result of burning fuel and chemical reactions that take place in the atmosphere. Some common sources include cars + other vehicles, pollen, construction work, and forest fires',
    'PM2.5 is one of the five pollutants that the Air Quality Index is based upon (ozone, nitrogen dioxide, sulfur dioxide, PM2.5, and PM10).',
    'PM2.5 poses the most threat to human health since it can permeate human organs such as the heart and lungs more easily due to its small diameter. Additionally, PM2.5 is one of the five pollutants that the Air Quality Index is based upon.',
    'There are models being developed to predict PM2.5 and air quality, but more research is needed.',
    'Use air, water, and energy more efficiently to reduce emissions. Set lights on a timer or motion sensor, install low flow sinks and toilets, and replace lightbulbs with fluorescents. Additionally, your state may have a program to help businesses be more environmentally friendly.',
    'Typically, air pollution levels rise when temperature rises. By measuring temperature, we can make sure our air quality trends are matching the air quality trends measured by other scientists.',
    'Older adults who are exposed to Unhealthy and above levels of air pollution according to the Air Quality Index can experience reduced lung function, difficulty breathing, chest tightness, and a variety of other respiratory symptoms. Children are the most susceptible, however, as they breathe at a faster rate than adults, and their lungs are still developing.',
    'You can donate to our lab group, download our app, and follow us on twitter @AirEmory.',
    'Carpool, use public transportation, avoid taking multiple trips for errands you could have accomplished in one trip, ride a bike, keep your thermostat at 78 in the summer and 68 in the winter, and upgrade your appliances to energy efficient appliances if possible.',
    'Check the Air Quality Index daily before exercising outside, letting your kids play outside, or spending an extended amount of time outside. If the Air Quality Index is Good, Moderate, or Unhealthy for Sensitive Groups, it should be fine to spend time outside.',
    'People with lung disease, heart disease, asthma, people who are sensitive to ozone or other specific pollutants, and adults and children who spend an especially large amount of time outside.',
    'We are planning to install a network of sensors around Emory’s campus and in the westside of Atlanta.',
    





    ];

    return Scaffold(
      appBar: AppBar(
       title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset(
                 'assets/cloud.png',
                  fit: BoxFit.contain,
                  height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Air Emory FAQ'))
            ],

          ),
     ),
     body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(
              title: Text(questions[index], 
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0, fontWeightDelta: 2)),
              subtitle: Text(answers[index], 
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5, color: Colors.grey)),
              onTap: () { //                                  <-- onTap
                  setState(() {
                    questions.insert(index, answers[index]);
                  });
              }
            ),
          );
        },
      )
    );
    }



}