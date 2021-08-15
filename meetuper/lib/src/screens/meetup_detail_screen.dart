import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';

class MeetupDetailScreen extends StatelessWidget {

  static final String route = '/meetupDetail';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('I am meetup detail screen'),
      ),
      appBar: AppBar(
        title: Text('Meetup detail'),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

}