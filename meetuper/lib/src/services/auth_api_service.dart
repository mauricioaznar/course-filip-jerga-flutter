import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/models/user.dart';
import 'package:meetuper/src/utils/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  static final AuthApiService _singleton = AuthApiService._internal();
  String? _token;

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

  Future<Map<String, dynamic>?> _decodedtoken() async {
    final token = await this.getToken();

    if (token != null) {
      final decodedToken = decode(token);
      return decodedToken;
    }
    return null;
  }

  Future<bool> _persistToken(token) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('token', token);
  }

  Future<bool> _saveToken(String? token) async {
    if (token != null) {
      await _persistToken(token);
      _token = token;
      return true;
    }
    return false;
  }

  void initUserFromToken() async {
    final decodedToken = await _decodedtoken();
    if (decodedToken != null) {
      authUser = User.fromJSON(decodedToken);
    }
  }

  Future<bool> isAuthenticated() async {
    final decodedToken = await _decodedtoken();
    if (decodedToken != null) {
      return decodedToken['exp'] * 1000 > DateTime.now().millisecond;
    }

    return false;
  }

  _removeAuthData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    _token = null;
    _authUser = null;
    await prefs.remove('token');
  }

  Future<bool> logout() async {
    try {
      await _removeAuthData();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> fetchAuthUser() async {
    try {
      final token = await this.getToken();
      if (token != null) {
        final url = Uri.http('10.0.2.2:3001', '/api/v1/users/me');
        final res =
            await http.post(url, headers: {'Authorization': 'Bearer $token'});
        final decodedBody = Map<String, dynamic>.from(json.decode(res.body));
        await _saveToken(decodedBody['token']);
        authUser = User.fromJSON(decodedBody);
        return authUser;
      }
    } catch (e) {
      _removeAuthData();
      throw Exception('Canoot fetch user');
    }
  }

  Future<dynamic> login(LoginFormData loginFormData) async {
    try {
      final body = json.encode(loginFormData.toJSON());
      final url = Uri.http('10.0.2.2:3001', '/api/v1/users/login');
      final res = await http
          .post(url, body: body, headers: {"Content-Type": "application/json"});
      final parsedData = Map<String, dynamic>.from(json.decode(res.body));
      if (res.statusCode == 200) {
        _saveToken(parsedData['token']);
        authUser = User.fromJSON(parsedData);
        return parsedData;
      } else {
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
      final res = await http
          .post(url, body: body, headers: {"Content-Type": "application/json"});
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
}
