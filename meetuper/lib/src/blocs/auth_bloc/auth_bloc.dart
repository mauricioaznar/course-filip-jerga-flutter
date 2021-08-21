import 'package:meetuper/src/blocs/auth_bloc/events.dart';
import 'package:meetuper/src/blocs/auth_bloc/state.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';

export 'package:meetuper/src/blocs/auth_bloc/events.dart';
export 'package:meetuper/src/blocs/auth_bloc/state.dart';

class AuthBloc extends BlocBase {
  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      // provide state to other screen via controller
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      // todo check if user is authenticated
      final bool isAuth = false;
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
