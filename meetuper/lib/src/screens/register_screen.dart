import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/models/arguments.dart';
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/screens/login_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/services/auth_api_service.dart';
import 'package:meetuper/src/utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final AuthApiService _authApiService = new AuthApiService();

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Create autovalidate

  bool _autovalidate = false;

  // 3. Create instance of RegisterFormData

  RegisterFormData _registerFormData = RegisterFormData();

  BuildContext? _buildContext;

  // 4. Create Register function and print all of the data

  _submit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // final password = _passwordController.value;
      // final email = _emailController.value;
      form.save();
      _register();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  _register() {
    print(_registerFormData.toJSON());
    widget._authApiService.register(_registerFormData).then((isValid) {
      if (isValid) {
        Navigator.pushReplacementNamed(context, '/',
            arguments: LoginScreenArguments(
                "You have been successfully register. Feel free to login now"));
      }
    }).catchError((res) {
      final snackBar = SnackBar(content: Text(res['errors']['message']));
      ScaffoldMessenger.of(_buildContext!).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: Builder(builder: (context) {
          _buildContext = context;
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                autovalidateMode: _autovalidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTitle(),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                        onSaved: (String? value) {
                          if (value != null) _registerFormData.name = value;
                        },
                        validator: composeValidators('name', [
                          requiredValidator,
                        ])
                        // 6. Required Validator
                        // 7. onSaved - save data to registerFormData
                        ),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Username',
                        ),
                        onSaved: (String? value) {
                          if (value != null) _registerFormData.username = value;
                        },
                        validator: composeValidators('username', [
                          requiredValidator,
                        ])),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                        ),
                        onSaved: (String? value) {
                          if (value != null) _registerFormData.email = value;
                        },
                        validator: composeValidators(
                            'email', [requiredValidator, emailValidator]),
                        keyboardType: TextInputType.emailAddress),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Avatar Url',
                        ),
                        onSaved: (String? value) {
                          if (value != null) _registerFormData.avatar = value;
                        },
                        keyboardType: TextInputType.url),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      onSaved: (String? value) {
                        if (value != null) _registerFormData.password = value;
                      },
                      validator: composeValidators(
                          'password', [requiredValidator, minLengthValidator]),
                      obscureText: true,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Password Confirmation',
                      ),
                      obscureText: true,
                      onSaved: (String? value) {
                        if (value != null)
                          _registerFormData.passwordConfirmation = value;
                      },
                      validator: composeValidators(
                          'password', [requiredValidator, minLengthValidator]),
                    ),
                    _buildLinksSection(),
                    _buildSubmitBtn()
                  ],
                ),
              ));
        }));
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: const Text('Submit'),
          onPressed: () {
            _submit();
          },
        ));
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.route,
                  arguments: LoginScreenArguments('Login from register'));
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MeetupHomeScreen.route);
              },
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
