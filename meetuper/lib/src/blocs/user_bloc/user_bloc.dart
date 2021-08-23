import 'dart:async';

import 'package:meetuper/src/blocs/user_bloc/state.dart';
import 'package:meetuper/src/models/meetup.dart';
import 'package:meetuper/src/models/user.dart';
import 'package:meetuper/src/services/auth_api_service.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc_provider.dart';
import 'events.dart';

export 'package:meetuper/src/blocs/user_bloc/state.dart';

class UserBloc extends BlocBase {
  final AuthApiService auth;

  UserBloc({required this.auth}) : assert(auth != null);

  final BehaviorSubject<UserState> _userSubject = BehaviorSubject<UserState>();
  Stream<UserState> get userState => _userSubject.stream;
  StreamSink<UserState> get userSink => _userSubject.sink;

  dispatch(UserEvent event) async {
    await for (var state in _userStream(event)) {
      userSink.add(state);
    }
  }

  Stream<UserState> _userStream(UserEvent event) async* {
    if (event is CheckUserPermissionsOnMeetup) {
      // todo change it for actual auth
      final bool isAuth = await auth.isAuthenticated();

      if (isAuth) {
        // todo get here actual user
        final User user = auth.authUser!;
        final meetup = event.meetup;

        if (_isUserMeetupOwner(meetup, user)) {
          yield UserIsMeetupOwner();
          return;
        }

        if (_isUserJoinedMeetup(meetup, user)) {
          yield UserIsMember();
        } else {
          yield UserIsNotMember();
        }
      } else {
        yield UserIsNotAuth();
      }
    }
  }

  bool _isUserMeetupOwner(Meetup meetup, User user) {
    // todo fix in the next lecture
    // return meetup.meetupCreator.id == user.id;
    return false;
  }

  bool _isUserJoinedMeetup(Meetup meetup, User user) {
    return user != null &&
        user.joinedMeetups.isNotEmpty &&
        user.joinedMeetups.contains(meetup.id);
    // return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
