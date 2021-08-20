import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

class CounterBloc {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  int _counter = 0;

  int get counter {
    return _counter;
  }

  Stream<int> get counterStream => _counterController.stream;

  StreamSink<int> get counterSink => _counterController.sink;

  CounterBloc() {
    _streamController.stream.listen(_handleIncrement);
  }

  _handleIncrement(int data) {
    _counter = _counter + data;
    counterSink.add(_counter);
  }

  void dispose() {
    _streamController.close();
    _counterController.close();
  }

  increment(int incrementer) {
    _streamController.sink.add(incrementer);
  }
}

class CounterBlocProvider extends StatefulWidget {
  final CounterBloc bloc;
  final Widget child;

  CounterBlocProvider({
    Key? key,
    required this.child,
  })  : bloc = CounterBloc(),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CounterBlocProviderState();
  }

  static CounterBloc of(BuildContext context) {
    _CounterBlocProviderInherited provider =
        (context.findAncestorWidgetOfExactType<_CounterBlocProviderInherited>()
            as _CounterBlocProviderInherited);
    return provider.bloc;
  }
}

class _CounterBlocProviderState extends State<CounterBlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _CounterBlocProviderInherited(
        child: widget.child, bloc: widget.bloc);
  }
}

class _CounterBlocProviderInherited extends InheritedWidget {
  final CounterBloc bloc;

  _CounterBlocProviderInherited(
      {required Widget child, required this.bloc, Key? key})
      : super(key: key, child: child) {}

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
