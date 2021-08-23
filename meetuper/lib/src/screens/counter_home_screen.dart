import 'package:flutter/material.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  CounterHomeScreen({String title = ''}) : _title = title;

  @override
  State<StatefulWidget> createState() {
    return CounterHomeScreenState();
  }
}

class CounterHomeScreenState extends State<CounterHomeScreen> {
  int _counter = 0;

  _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text('Welcome in ${widget._title}, lets increment number',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 15.0)),
              Text('Counter $_counter',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 30.0)),
              RaisedButton(
                  child: Text('Go to detail'),
                  onPressed: () {
                    Navigator.pushNamed(context, MeetupDetailScreen.route);
                  })
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _increment();
            },
            tooltip: 'Increment Text',
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomNavigation(
          currentIndex: 0,
          onChange: (int i) {},
        ),
        appBar: AppBar(title: Text(widget._title)));
  }
}
