import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/services/meetup_api_service.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({required this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static final String route = '/meetupHome';

  @override
  State<StatefulWidget> createState() {
    return MeetupHomeScreenState();
  }
}

class MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<CustomText> customTextList = [
    CustomText(key: UniqueKey(), name: 'adsf'),
    CustomText(key: UniqueKey(), name: 'asd2'),
    CustomText(key: UniqueKey(), name: 'asdfasd')
  ];

  final MeetupApiService _api = MeetupApiService();

  List<Meetup> _meetups = [];

  _shuffleList() {
    setState(() {
      customTextList.shuffle();
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchMeetups();
  }

  _fetchMeetups () async {
    var meetups = await _api.fetchMeetups();
    setState(() {
      _meetups = meetups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_MeetupTitle(), _MeetupList(meetups: _meetups,)])),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // _shuffleList();
          },
        ),
        appBar: AppBar(title: Text('Home')));
  }
}


class _MeetupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(20.0),
        child: Text('Featured Meetup',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)));
  }
}

class _MeetupCard extends StatelessWidget {
  Meetup _meetup;

  _MeetupCard({required Meetup meetup})
  : _meetup = meetup;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: CircleAvatar(
          radius: 35.0,
          backgroundImage: NetworkImage(_meetup.image),
        ),
        title: Text(_meetup.title),
        subtitle: Text(_meetup.description),
      ),
      ButtonBarTheme(
          data: ButtonBarThemeData(),
          child: new ButtonBar(
            children: [
              TextButton(onPressed: () {
                Navigator.pushNamed(context, '/meetupDetail', arguments: MeetupDetailArguments(id: _meetup.id));
              }, child: Text('Visit meetup')),
              TextButton(onPressed: () {}, child: Text('Favorite'))
            ],
          ))
    ]));
  }
}

class _MeetupList extends StatelessWidget {
  List<Meetup> _meetups;

  _MeetupList({required List<Meetup> meetups}) :
      _meetups = meetups;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _meetups.length * 2,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _MeetupCard(meetup: _meetups[index]);
        },
      ),
    );
  }
}


class CustomText extends StatefulWidget {
  final String name;

  CustomText({required Key key, required name})
      : name = name,
        super(key: key);

  @override
  createState() => CustomTextState();
}

class CustomTextState extends State<CustomText> {
  List colors = [
    Colors.red,
    Colors.blue,
    Colors.brown,
    Colors.orange,
    Colors.grey,
    Colors.deepPurple
  ];
  Random random = Random();
  late Color color;

  @override
  void initState() {
    super.initState();
    color = colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text('Custom Text of $color'), color: color, height: 150.0);
  }
}