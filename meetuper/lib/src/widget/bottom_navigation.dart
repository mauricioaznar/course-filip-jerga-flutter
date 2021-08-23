import 'package:flutter/material.dart';
import 'package:meetuper/src/blocs/user_bloc/user_bloc.dart';

class BottomNavigation extends StatelessWidget {
  final _currentIndex;

  final Function(int) onChange;
  final UserState? userState;

  BottomNavigation(
      {required Function(int) onChange,
      UserState? userState,
      required int currentIndex})
      : onChange = onChange,
        userState = userState,
        _currentIndex = currentIndex;

  _handleTap(int index, {required BuildContext context}) {
    if (userState is UserIsMember || userState is UserIsMeetupOwner) {
      onChange(index);
    } else {
      if (index != 0) {
        final snackBar = SnackBar(
          content: Text('Not allowed, please join.'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _renderColor() {
    print(userState);
    if (userState is UserIsMember || userState is UserIsMeetupOwner) {
      return null;
    } else {
      return Colors.black12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          _handleTap(index, context: context);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Detail'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notes, color: _renderColor()), label: 'Threads'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people, color: _renderColor()), label: 'People'),
        ]);
  }
}
