import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/blocs/counter_bloc.dart';
import 'package:meetuper/src/blocs/meetup_bloc.dart';
import 'package:meetuper/src/models/arguments.dart';
import 'package:meetuper/src/screens/counter_home_screen.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/screens/register_screen.dart';

void main() {
  // return runApp(AppStore(child: MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: LoginScreen(),
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
