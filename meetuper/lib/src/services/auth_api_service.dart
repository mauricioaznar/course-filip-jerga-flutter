import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/models/meetup.dart';

class AuthApiService {
  static final AuthApiService _singleton = AuthApiService._internal();

  factory AuthApiService() {
    return _singleton;
  }

  AuthApiService._internal();

  Future<dynamic> login(LoginFormData loginFormData) async {
    try {
      final body = json.encode(loginFormData.toJSON());
      final url = Uri.http('10.0.2.2:3001', '/api/v1/users/login');
      final res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json"
      });
      final parsedData = Map<String, dynamic>.from(json.decode(res.body));
      if (res.statusCode == 200) {
        return parsedData;
      } else {
        print('asdfa');
        print(parsedData);
        throw parsedData;
      }
    } catch (e) {
      throw e;
    }
  }

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
