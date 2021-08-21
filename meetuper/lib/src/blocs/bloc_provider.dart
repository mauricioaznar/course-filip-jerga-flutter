import 'dart:async';

import 'package:flutter/cupertino.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;

  final Widget child;

  BlocProvider({Key? key, required Widget child, required T bloc})
      : bloc = bloc,
        child = child,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BlocProviderState<T>();
  }

  static T of<T extends BlocBase>(BuildContext context) {
    _BlocProviderInherited<T> provider = (context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()
        ?.widget as _BlocProviderInherited<T>);

    return provider.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(child: widget.child, bloc: widget.bloc);
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _BlocProviderInherited<T extends BlocBase> extends InheritedWidget {
  final T bloc;

  _BlocProviderInherited({required Widget child, required this.bloc, Key? key})
      : super(key: key, child: child) {}

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
