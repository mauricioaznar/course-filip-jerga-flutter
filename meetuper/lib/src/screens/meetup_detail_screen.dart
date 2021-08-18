import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/services/meetup_api_service.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';

class MeetupDetailScreen extends StatefulWidget {
  static final String route = '/meetupDetail';
  final MeetupApiService api = MeetupApiService();

  final String meetupId;

  MeetupDetailScreen({required this.meetupId});

  @override
  State<StatefulWidget> createState() {
    return MeetupDetailScreenState();
  }
}

class MeetupDetailScreenState extends State<MeetupDetailScreen> {
  Meetup? _meetup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchMeetupApi();
  }

  _fetchMeetupApi() async {
    Meetup meetup = await widget.api.fetchMeetupById(widget.meetupId);
    print(meetup.description);
    setState(() {
      _meetup = meetup;
    });
  }

  _buildBody() {
    print(_meetup);
    if (_meetup != null) {
      return ListView(
        children: [
          HeaderSection(meetup: _meetup!),
          TitleSection(meetup: _meetup!),
          AdditionalInfoSection(meetup: _meetup!),
          Padding(
            padding: EdgeInsets.all(20),
            child:     Align(
              alignment: Alignment.centerLeft,
              child: Text(_meetup!.description +
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            ),
          )
        ],
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetupId = widget.meetupId;
    // TODO: implement build
    return Scaffold(
      body: Center(child: _buildBody()),
      appBar: AppBar(
        title: Text('Meetup detail'),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class AdditionalInfoSection extends StatelessWidget {
  final Meetup _meetup;

  AdditionalInfoSection({required Meetup meetup}) : _meetup = meetup;

  String _capitalize(String? word) {
    if (word != null && word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return '';
    }
  }

  Widget _buildColumn(String label, String text, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13.0, color: color)),
        Text(_capitalize(text),
            style: TextStyle(
                fontWeight: FontWeight.w500, color: color, fontSize: 25.0))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Padding(
      child: Row(children: <Widget>[
        _buildColumn('CATEGORY', _meetup.category.name, color),
        _buildColumn('FROM', _meetup.timeFrom, color),
        _buildColumn('TO', _meetup.timeTo, color),
      ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      padding: EdgeInsets.all(10),
    );
  }
}

class TitleSection extends StatelessWidget {
  final Meetup _meetup;

  TitleSection({required Meetup meetup}) : _meetup = meetup;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Padding(
      child: Row(children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_meetup.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_meetup.shortInfo,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[500]))
            ],
          ),
        ),
        Icon(Icons.people, color: color),
        Text('${_meetup.joinedPeopleCount} People')
      ]),
      padding: EdgeInsets.all(30),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Meetup _meetup;

  HeaderSection({required Meetup meetup}) : _meetup = meetup;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Image.network(_meetup.image,
            width: width, height: 240, fit: BoxFit.cover),
        Container(
            width: width,
            height: 100,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
            child: Padding(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(
                      'https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg'),
                ),
                title: Text(_meetup.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                subtitle: Text(_meetup.shortInfo,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            ))
      ],
      alignment: AlignmentDirectional.bottomStart,
    );
  }
}
