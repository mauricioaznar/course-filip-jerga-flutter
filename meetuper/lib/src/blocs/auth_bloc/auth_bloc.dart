import 'dart:async';

import 'package:meetuper/src/blocs/auth_bloc/events.dart';
import 'package:meetuper/src/blocs/auth_bloc/state.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/services/auth_api_service.dart';

export 'package:meetuper/src/blocs/auth_bloc/events.dart';
export 'package:meetuper/src/blocs/auth_bloc/state.dart';

class AuthBloc extends BlocBase {
  final AuthApiService authApiService;
  final StreamController<AuthenticationState> _authController =
      StreamController<AuthenticationState>();

  AuthBloc({required this.authApiService}) : assert(authApiService != null);

  Stream<AuthenticationState> get authStream => _authController.stream;

  StreamSink<AuthenticationState> get authSink => _authController.sink;

  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      authSink.add(state);
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      // todo check if user is authenticated
      final bool isAuth = await authApiService.isAuthenticated();

      if (isAuth) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is InitLogging) {
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
