import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/screens/register_screen.dart';
import 'package:meetuper/src/services/auth_api_service.dart';
import 'package:meetuper/src/utils/validator.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';
  final AuthApiService authApi = AuthApiService();

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  LoginFormData _loginFormData = LoginFormData();

  BuildContext? _buildContext;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autovalidate = false;

  final username = 'filip@gmail.com';
  final password = 'testtest';

  _submit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // final password = _passwordController.value;
      // final email = _emailController.value;
      form.save();
      _login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void _login() {
    widget.authApi.login(_loginFormData).then((data) {
    }).catchError((res) {
      print(res['']);
      print('nvnvnv');
      // Scaffold.of(_buildContext!)
      //     .showSnackBar(SnackBar(content: res['errors']['message']));
    });
  }

  @override
  void initState() {
    super.initState();
    // _emailController.addListener(() {
    //   print(_emailController.text);
    // });
    // _passwordController.addListener(() {
    //   print(_passwordController.text);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // _emailController.dispose();
    // _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (context) {
            _buildContext = context;
            return Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  autovalidateMode: _autovalidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  key: _formKey,
                  // Provide key
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          'Login And Explore',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                          key: _emailKey,
                          style: Theme.of(context).textTheme.headline6,
                          onSaved: (String? value) {
                            if (value != null) _loginFormData.email = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                          ),
                          validator: composeValidators('email', [
                            requiredValidator,
                            minLengthValidator,
                            emailValidator,
                          ])),
                      TextFormField(
                          key: _passwordKey,
                          style: Theme.of(context).textTheme.headline6,
                          onSaved: (String? value) {
                            if (value != null) _loginFormData.password = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                          validator: composeValidators('email', [
                            requiredValidator,
                            minLengthValidator,
                          ])),
                      _buildLinks(),
                      Container(
                          alignment: Alignment(-1.0, 0.0),
                          margin: EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            child: const Text('Submit'),
                            onPressed: () => {_submit()},
                          ))
                    ],
                  ),
                ));
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RegisterScreen.route);
            },
            tooltip: 'Go to register',
            child: Icon(Icons.app_registration)),
        appBar: AppBar(title: Text('Login')));
  }

  _buildLinks() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                    context, RegisterScreen.route),
                child: Text('Not registered yet? register now!',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ))),
            GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                    context, MeetupHomeScreen.route),
                child: Text('Continue to Home Page',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    )))
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}