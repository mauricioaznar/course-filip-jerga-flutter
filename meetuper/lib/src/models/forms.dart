import 'package:meetuper/src/models/category.dart';

class LoginFormData {
  String email = '';
  String password = '';

  Map<String, dynamic> toJSON() => {'email': email, 'password': password};
}

class RegisterFormData {
  String email = '';
  String username = '';
  String name = '';
  String password = '';
  String passwordConfirmation = '';
  String avatar = '';

  Map<String, dynamic> toJSON() => {
        'email': email,
        'username': username,
        'name': name,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'avatar': avatar
      };
}

class MeetupFormData {
  String location = '';
  String title = '';
  DateTime? startDate = null;
  Category? category = null;
  String image = '';
  String shortInfo = '';
  String description = '';
  String timeTo = '';
  String timeFrom = '';

  Map<String, dynamic> toJSON() => {
        'location': location,
        'title': title,
        'startDate': startDate != null ? startDate!.toIso8601String() : '',
        'category': category != null ? category!.id : '',
        'image': image,
        'shortInfo': shortInfo,
        'description': description,
        'timeTo': timeTo,
        'timeFrom': timeFrom
      };
}
