import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // 2. Create autovalidate

  bool _autovalidate = false;

  // 3. Create instance of RegisterFormData

  RegisterFormData _registerFormData = RegisterFormData();

  // 4. Create Register function and print all of the data

  _submit () {
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
    print(_registerFormData.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Register')
        ),
        body: Builder(
            builder: (context) {
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
                          validator: composeValidators('email', [
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
                        ),
                        TextFormField(
                            style: Theme.of(context).textTheme.headline6,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress
                        ),
                        TextFormField(
                            style: Theme.of(context).textTheme.headline6,
                            decoration: InputDecoration(
                              hintText: 'Avatar Url',
                            ),
                            keyboardType: TextInputType.url
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline6,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline6,
                          decoration: InputDecoration(
                            hintText: 'Password Confirmation',
                          ),
                          obscureText: true,
                        ),
                        _buildLinksSection(),
                        _buildSubmitBtn()
                      ],
                    ),
                  )
              );
            }
        )
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold
        ),
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
        )
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
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
                Navigator.pushNamed(context, "/meetups");
              },
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              )
          )
        ],
      ),
    );
  }
}



