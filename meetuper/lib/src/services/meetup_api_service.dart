import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/meetup.dart';

class MeetupApiService {
  static final MeetupApiService _singleton = MeetupApiService._internal();

  factory MeetupApiService() {
    return _singleton;
  }

  MeetupApiService._internal();

  // android emulator: 10.0.2.2 https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan

  fetchMeetups() async {
    final url = Uri.http('10.0.2.2:3001', '/api/v1/meetups');
    final res = await http.get(url);
    final List parsedMeetups = json.decode(res.body);
    return parsedMeetups.map((val) => Meetup.fromJSON(val)).toList();
  }

  Future<Meetup> fetchMeetupById (String id) async {
    final url = Uri.http('10.0.2.2:3001', '/api/v1/meetups/$id');
    final res = await http.get(url);
    final parsedMeetup = json.decode(res.body);
    return Meetup.fromJSON(parsedMeetup);
  }
}
