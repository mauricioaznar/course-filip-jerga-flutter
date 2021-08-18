import 'package:flutter/material.dart';

class AppStore extends StatefulWidget {
  final Widget child;

  AppStore({ required child })
    : child = child;

  _AppStoreState createState() => _AppStoreState();


  static _AppStoreState of (BuildContext context) {
    final _InheritedAppState? result = context.dependOnInheritedWidgetOfExactType<_InheritedAppState>();
    return result!.data;
  }
}

class _AppStoreState extends State<AppStore> {
  String testingData = 'Testing data (:';



  Widget build(BuildContext context) {
    return _InheritedAppState(child: widget.child, data: this);
  }
}

class _InheritedAppState extends InheritedWidget {
  final _AppStoreState data;

  _InheritedAppState({ required Widget child, required this.data }) :
      super(child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}