import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/models/user.dart';
import 'package:meetuper/src/utils/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  static final AuthApiService _singleton = AuthApiService._internal();
  String?  _token ;
  User? _authUser;

  factory AuthApiService() {
    return _singleton;
  }

  AuthApiService._internal();

  set authUser(User? value) {
    _authUser = value;
  }

  User? get authUser => _authUser;

  Future<String?> getToken() async {
    if (_token != null) {
      return _token;
    } else {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      return prefs.getString('token');
    }
  }


  Future<bool> _persistToken(token) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('token', token);
  }


  Future<bool> _saveToken (String? token) async {
    if (token != null) {
      await _persistToken(token);
      _token = token;
      return true;
    }
    return false;
  }


  Future<bool> isAuthenticated () async {
    final token = await this.getToken();
    if (token != null) {

      final decodedToken = decode(token);


      final isValidToken = decodedToken['exp'] * 1000 > DateTime.now().millisecond;

      if (isValidToken) {
        authUser = User.fromJSON(decodedToken);
      }

      return isValidToken;
    }

    return false;
  }

  _removeAuthData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    _token = null;
    _authUser = null;
    return await prefs.remove('token');
  }

  Future<bool> logout () async {
      try {
        return await _removeAuthData();
      } catch(e) {
        return false;
      }
  }

  Future<dynamic> login(LoginFormData loginFormData) async {
    try {
      final body = json.encode(loginFormData.toJSON());
      final url = Uri.http('10.0.2.2:3001', '/api/v1/users/login');
      final res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json"
      });
      final parsedData = Map<String, dynamic>.from(json.decode(res.body));
      if (res.statusCode == 200) {
        _saveToken(parsedData['token']);
        authUser = User.fromJSON(parsedData);
        return parsedData;
      } else {
        print(parsedData);
        throw parsedData;
      }
    } catch (e) {
      // todo improve error handling
      throw e;
    }
  }

  Future<bool> register(RegisterFormData registerFormData) async {
    try {
      final body = json.encode(registerFormData.toJSON());
      final url = Uri.http('10.0.2.2:3001', '/api/v1/users/register');
      final res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json"
      });
      final parsedData = Map<String, dynamic>.from(json.decode(res.body));
      if (res.statusCode == 200) {
        return true;
      } else {
        // todo improve error handling
        print(parsedData);
        throw parsedData;
      }
    } catch (e) {
      // todo improve error handling
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
