import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meetuper/src/blocs/auth_bloc/events.dart';
import 'package:meetuper/src/blocs/auth_bloc/state.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/services/auth_api_service.dart';

export 'package:meetuper/src/blocs/auth_bloc/events.dart';
export 'package:meetuper/src/blocs/auth_bloc/state.dart';

class AuthBloc extends BlocBase {
  final AuthApiService authApiService;

  final StreamController<AuthenticationState> _authController =
      StreamController<AuthenticationState>.broadcast();
  Stream<AuthenticationState> get authStream => _authController.stream;
  StreamSink<AuthenticationState> get authSink => _authController.sink;

  AuthBloc({required this.authApiService}) : assert(authApiService != null);

  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      authSink.add(state);
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool isAuth = await authApiService.isAuthenticated();

      if (isAuth) {
        await authApiService.fetchAuthUser().catchError((_) {
          dispatch(LoggedOut(message: 'Error'));
        });
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated(message: 'Logout');
      }
    }

    if (event is InitLogging) {
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated(logout: true, message: event.message);
    }
  }

  @override
  void dispose() {
    _authController.close();
  }
}
