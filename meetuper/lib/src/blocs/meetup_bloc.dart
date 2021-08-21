import 'dart:async';

import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/services/meetup_api_service.dart';

import 'bloc_provider.dart';

class MeetupBloc implements BlocBase {
  final MeetupApiService _apiService = MeetupApiService();

  final StreamController<List<Meetup>> _meetupController =
      StreamController.broadcast();

  Stream<List<Meetup>> get meetups {
    return _meetupController.stream;
  }

  StreamSink<List<Meetup>> get _inMeetups {
    return _meetupController.sink;
  }

  final StreamController<Meetup> _meetupDetailController =
      StreamController.broadcast();

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

  void dispose() {
    _meetupController.close();
  }
}
