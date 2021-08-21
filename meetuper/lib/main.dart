import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/blocs/counter_bloc.dart';
import 'package:meetuper/src/blocs/meetup_bloc.dart';
import 'package:meetuper/src/models/arguments.dart';
import 'package:meetuper/src/screens/counter_home_screen.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/screens/register_screen.dart';
import 'package:meetuper/src/services/auth_api_service.dart';

void main() {
  // return runApp(AppStore(child: MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
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
  AuthBloc? authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc!.dispatch(AppStarted());
    super.initState();
  }

  _buildStream() {
    return StreamBuilder<AuthenticationState>(
        stream: authBloc!.authStream,
        initialData: AuthenticationUninitialized(),
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;
          print(state);
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }

          if (state is AuthenticationAuthenticated) {
            //
            return BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupHomeScreen(),
            );
          }

          if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          }

          if (state is AuthenticationLoading) {
            return LoadingScreen();
          }

          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: _buildStream(),
        // home: CounterHomeScreen(title: 'Navigator'),
        // home: BlocProvider<CounterBloc>(
        //     bloc: CounterBloc(), child: CounterHomeScreen(title: 'Title')),
        onGenerateRoute: (RouteSettings settings) {
          print('${settings.name}');
          if (settings.name == MeetupDetailScreen.route) {
            final MeetupDetailArguments arguments =
                settings.arguments as MeetupDetailArguments;
            return MaterialPageRoute(
                builder: (context) => BlocProvider<MeetupBloc>(
                    child: MeetupDetailScreen(meetupId: arguments.id),
                    bloc: MeetupBloc()));
          } else if (settings.name == RegisterScreen.route) {
            return MaterialPageRoute(builder: (context) => RegisterScreen());
          } else if (settings.name == LoginScreen.route) {
            final LoginScreenArguments? arguments =
                settings.arguments as LoginScreenArguments?;
            final message = arguments?.message;
            return MaterialPageRoute(
                builder: (context) => LoginScreen(message: message));
          } else if (settings.name == MeetupHomeScreen.route) {
            return MaterialPageRoute(
                builder: (context) => BlocProvider<MeetupBloc>(
                    child: MeetupHomeScreen(), bloc: MeetupBloc()));
          }
        }
        // routes: {
        //   MeetupHomeScreen.route: (context) => MeetupHomeScreen(),
        //   MeetupDetailScreen.route: (context) => MeetupDetailScreen()
        // },
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
