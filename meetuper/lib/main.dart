import 'package:flutter/material.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/posts_screen.dart';

import 'src/screens/counter_home_screen.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My',
      theme: ThemeData(primarySwatch: Colors.green),
      // home: CounterHomeScreen(title: 'Navigator'),
      home: PostsScreen(),
      routes: {
        MeetupDetailScreen.route: (context) => MeetupDetailScreen()
      },
    );
  }
}

