import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/blocs/meetup_bloc.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/services/auth_api_service.dart';
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

  List<Meetup> _meetups = [];

  _shuffleList() {
    setState(() {
      customTextList.shuffle();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final meetupBloc = BlocProvider.of<MeetupBloc>(context);
    meetupBloc.fetchMeetups();
    meetupBloc.meetups.listen((data) {
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_MeetupTitle(), _MeetupList()])),
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
  final AuthApiService _apiService = AuthApiService();

  _buildWelcomeTitle() {
    return FutureBuilder<bool>(
        future: _apiService.isAuthenticated(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            final authUser = _apiService.authUser!;
            Widget avatar = authUser.avatar != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(authUser.avatar),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  );
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  avatar,
                  Text('Welcome ${authUser.name}'),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        _apiService.logout().then((val) {
                          if (val == true) {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.route);
                          }
                        });
                      },
                      child: Text('Logout',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          )))
                ],
              ),
            );
          } else {
            return Container(width: 0, height: 0);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Featured Meetup',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
          _buildWelcomeTitle()
        ]));
  }
}

class _MeetupCard extends StatelessWidget {
  Meetup _meetup;

  _MeetupCard({required Meetup meetup}) : _meetup = meetup;

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
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/meetupDetail',
                        arguments: MeetupDetailArguments(id: _meetup.id));
                  },
                  child: Text('Visit meetup')),
              TextButton(onPressed: () {}, child: Text('Favorite'))
            ],
          ))
    ]));
  }
}

class _MeetupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Meetup>>(
          stream: BlocProvider.of<MeetupBloc>(context).meetups,
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<Meetup>> snapshot) {
            final meetups = snapshot.data;
            final length = meetups?.length ?? 0;
            return ListView.builder(
              itemCount: (length) * 2,
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;

                final meetup = meetups != null
                    ? _MeetupCard(meetup: meetups[index])
                    : Container();
                return meetup;
              },
            );
          }),
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
