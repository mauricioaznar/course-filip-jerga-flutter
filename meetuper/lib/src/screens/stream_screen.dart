import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetuper/src/blocs/bloc_provider.dart';
import 'package:meetuper/src/blocs/counter_bloc.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';

class StreamHomeScreen extends StatefulWidget {
  final String _title;

  StreamHomeScreen({required String title}) : _title = title;

  @override
  State<StatefulWidget> createState() {
    return StreamHomeScreenState();
  }
}

class StreamHomeScreenState extends State<StreamHomeScreen> {
  CounterBloc? counterBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    counterBloc = BlocProvider.of<CounterBloc>(context);
  }

  // use broadcast when getting subscribed in multiple places
  // streams are powerfull because they dont refresh the whole widget they ccan only refresh parts of it.

  // final StreamController<int> _streamController =
  //     StreamController<int>.broadcast();
  // final StreamController<int> _counterController =
  //     StreamController<int>.broadcast();
  //
  // final StreamTransformer<int, int> _streamTransformer =
  //     StreamTransformer.fromHandlers(handleData: (data, sink) {
  //   print('Calling from handle data');
  //   sink.add(data ~/ 2);
  // });
  // int _counter = 0;

  // initState() {
  //   super.initState();
  //   _streamController.stream
  // .map((data) {
  //   return data + 1;
  // })
  // .transform(_streamTransformer)
  // .listen((data) {
  // _counter = _counter + data;
  // print(_counter);
  // _counterController.sink.add(_counter);
  // });
  // _streamController.stream.listen((data) {
  //   print('asdfasdfasd');
  // });
  // }

  _increment() {
    counterBloc!.increment(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text('Welcome in ${widget._title}, lets increment number',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 15.0)),
              StreamBuilder(
                  stream: counterBloc!.counterStream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    // hasData will be false when initialData is not defined
                    if (snapshot.hasData) {
                      return Text('Counter ${counterBloc!.counter}',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: 30.0));
                    } else {
                      return Text('No data',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: 30.0));
                    }
                  }),
              RaisedButton(
                  child: StreamBuilder(
                      stream: counterBloc!.counterStream,
                      initialData: counterBloc!.counter,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        // hasData will be false when initialData is not defined
                        if (snapshot.hasData) {
                          return Text('Counter ${counterBloc!.counter}',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 30.0));
                        } else {
                          return Text('No data',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 30.0));
                        }
                      }),
                  onPressed: () {
                    _increment();
                  })
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _increment();
            },
            tooltip: 'Increment Text',
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomNavigation(),
        appBar: AppBar(title: Text(widget._title)));
  }
}
