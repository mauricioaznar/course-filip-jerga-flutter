import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/blocs/counter_bloc.dart';
import 'package:meetuper/src/blocs/meetup_bloc.dart';
import 'package:meetuper/src/blocs/user_bloc/user_bloc.dart';
import 'package:meetuper/src/models/arguments.dart';
import 'package:meetuper/src/screens/counter_home_screen.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/screens/meetup_create_screen.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/screens/register_screen.dart';
import 'package:meetuper/src/services/auth_api_service.dart';

void main() {
  return runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
        child: MeetuperApp(), bloc: AuthBloc(authApiService: AuthApiService()));
  }
}

class MeetuperApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MeetuperAppState();
  }
}

class _MeetuperAppState extends State<MeetuperApp> {
  late AuthBloc authBloc;
  int i = 0;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(AppStarted());
    authBloc.authStream.listen((event) {
      print(i);
    });
    print('getting called again');
    super.initState();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: StreamBuilder<AuthenticationState>(
          stream: authBloc.authStream,
          initialData: AuthenticationUninitialized(),
          builder: (BuildContext context,
              AsyncSnapshot<AuthenticationState> snapshot) {
            final state = snapshot.data!;
            print(state);
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            }

            if (state is AuthenticationAuthenticated) {
              return BlocProvider<MeetupBloc>(
                bloc: MeetupBloc(),
                child: MeetupHomeScreen(),
              );
            }

            if (state is AuthenticationUnauthenticated) {
              final settings = ModalRoute.of(context)!.settings;
              String message = '';
              if (settings.arguments != null) {
                final arguments = settings.arguments as LoginScreenArguments;
                message = arguments.message ?? state.message;
                state.message = '';
              }

              return LoginScreen(message: message);
            }

            if (state is AuthenticationLoading) {
              return LoadingScreen();
            }

            return Container();
          }),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailScreen.route) {
          final MeetupDetailArguments arguments =
              settings.arguments as MeetupDetailArguments;
          return MaterialPageRoute(
              builder: (context) => BlocProvider<MeetupBloc>(
                  child: BlocProvider<UserBloc>(
                    bloc: UserBloc(auth: AuthApiService()),
                    child: MeetupDetailScreen(meetupId: arguments.id),
                  ),
                  bloc: MeetupBloc()));
        } else if (settings.name == RegisterScreen.route) {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        } else if (settings.name == LoginScreen.route) {
          final LoginScreenArguments? arguments =
              settings.arguments as LoginScreenArguments?;
          return MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(message: 'Login from onGenerateRoute'));
        } else if (settings.name == MeetupHomeScreen.route) {
          return MaterialPageRoute(
              builder: (context) => BlocProvider<MeetupBloc>(
                  child: MeetupHomeScreen(), bloc: MeetupBloc()));
        }
      },
      routes: {
        MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupHomeScreen(),
            ),
        RegisterScreen.route: (context) => RegisterScreen(),
        MeetupCreateScreen.route: (context) => MeetupCreateScreen()
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
