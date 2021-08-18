import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';

  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text('Register')),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Go to login',
            child: Icon(Icons.login)),
        appBar: AppBar(title: Text('Register')));
  }
}
