import 'package:flutter/material.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/screens/register_screen.dart';

void main() {
  // return runApp(AppStore(child: MyApp()));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My',
        theme: ThemeData(primarySwatch: Colors.purple),
        // home: CounterHomeScreen(title: 'Navigator'),
        home: RegisterScreen(),
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final MeetupDetailArguments arguments =
                settings.arguments as MeetupDetailArguments;
            return MaterialPageRoute(
                builder: (context) =>
                    MeetupDetailScreen(meetupId: arguments.id));
          } else if (settings.name == RegisterScreen.route) {
            return MaterialPageRoute(
                builder: (context) =>
                    RegisterScreen());
          } else if (settings.name == LoginScreen.route) {
            return MaterialPageRoute(
                builder: (context) =>
                    LoginScreen());
          } else if (settings.name == MeetupHomeScreen.route) {
            return MaterialPageRoute(
                builder: (context) =>
                    MeetupHomeScreen());
          }
        }
        // routes: {
        //   MeetupHomeScreen.route: (context) => MeetupHomeScreen(),
        //   MeetupDetailScreen.route: (context) => MeetupDetailScreen()
        // },
        );
  }
}
