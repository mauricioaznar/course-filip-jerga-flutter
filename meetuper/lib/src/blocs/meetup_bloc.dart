import 'dart:async';

import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/models/user.dart';
import 'package:meetuper/src/services/auth_api_service.dart';
import 'package:meetuper/src/services/meetup_api_service.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class MeetupBloc implements BlocBase {
  //  better idea would be to inject service in constructor
  final MeetupApiService _apiService = MeetupApiService();
  final AuthApiService authApiService = AuthApiService();

  final BehaviorSubject<List<Meetup>> _meetupController = BehaviorSubject();
  Stream<List<Meetup>> get meetups {
    return _meetupController.stream;
  }

  StreamSink<List<Meetup>> get _inMeetups {
    return _meetupController.sink;
  }

  final BehaviorSubject<Meetup> _meetupDetailController = BehaviorSubject();
  Stream<Meetup> get meetup {
    return _meetupDetailController.stream;
  }

  StreamSink<Meetup> get _inMeetup {
    return _meetupDetailController.sink;
  }

  fetchMeetups() async {
    final meetups = await _apiService.fetchMeetups();
    _inMeetups.add(meetups);
  }

  fetchMeetup(String meetupId) async {
    final meetup = await _apiService.fetchMeetupById(meetupId);
    _inMeetup.add(meetup);
  }

  void joinMeetup(Meetup meetup) {
    _apiService.joinMeetup(meetup.id).then((_) {
      User user = authApiService.authUser!;
      user.joinedMeetups.add(meetup.id);
      meetup.joinedPeople.add(user);
      meetup.joinedPeopleCount++;
      _inMeetup.add(meetup);
    }).catchError((err) => print(err));
  }

  void leaveMeetup(Meetup meetup) {
    _apiService.leaveMeetup(meetup.id).then((_) {
      User user = authApiService.authUser!;
      user.joinedMeetups.removeWhere((jMeetup) {
        return jMeetup == meetup.id;
      });
      meetup.joinedPeople.removeWhere((jUser) => jUser.id == user.id);
      meetup.joinedPeopleCount--;
      _inMeetup.add(meetup);
    }).catchError((err) => print(err));
  }

  void dispose() {
    _meetupController.close();
    _meetupDetailController.close();
  }
}
