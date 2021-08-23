import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/category.dart';
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Meetup> fetchMeetupById(String id) async {
    final url = Uri.http('10.0.2.2:3001', '/api/v1/meetups/$id');
    final res = await http.get(url);
    final parsedMeetup = json.decode(res.body);
    return Meetup.fromJSON(parsedMeetup);
  }

  Future<String> createMeetup(MeetupFormData formData) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      final token = prefs.getString('token');
      print(formData.toJSON());
      final body = json.encode(formData.toJSON());
      final url = Uri.http('10.0.2.2:3001', '/api/v1/meetups');
      final res = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: body);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        print(res.body);
        throw ('Errror ${res.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> joinMeetup(String meetupId) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      final token = prefs.getString('token');
      final request =
          Uri.http('10.0.2.2:3001', '/api/v1/meetups/$meetupId/join');
      final res =
          await http.post(request, headers: {'Authorization': 'Bearer $token'});
      return true;
    } catch (e) {
      throw Exception('Cannot join meetup');
    }
  }

  Future<bool> leaveMeetup(String meetupId) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      final token = prefs.getString('token');
      final request =
          Uri.http('10.0.2.2:3001', '/api/v1/meetups/$meetupId/leave');
      final res =
          await http.post(request, headers: {'Authorization': 'Bearer $token'});
      return true;
    } catch (e) {
      throw Exception('Cannot join meetup');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final request = Uri.http('10.0.2.2:3001', '/api/v1/categories');
    final res = await http.get(request);
    final List decodedBody = json.decode(res.body);
    return decodedBody.map((val) => Category.fromJSON(val)).toList();
  }
}
