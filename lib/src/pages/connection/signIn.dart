import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/services/authentication_service.dart';

import '../../app.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  const SignInPage({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String name;
  String email = '';
  String password = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Your name.',
                  labelText: 'Name',
                ),
                validator: (String value) {
                  return value == "" ? "Name is empty." : null;
                },
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Your email address.',
                  labelText: 'Email',
                ),
                validator: (String value) {
                  return !value.contains('@') && !value.contains('.') ? "It's empty or not an email address." : null;
                },
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Your password',
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (String value) {
                  return value == "" ? 'The password is empty.' : null;
                },
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Confirm your password',
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (String value) {
                  return value == "" || value != password ? 'The password is empty or not corresponding.' : null;
                },
                onChanged: (val) {
                  setState(() => password2 = val);
                },
              ),
              SizedBox(height: 40),
              RaisedButton(
                color: Colors.black,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });

                    UserData userData = UserData(name: this.name);

                    dynamic result = await AuthenticationService().createUserWithEmailAndPassword(userData, email, password);

                    if (result is FullUser) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => App()),
                      );
                    } else {
                      setState(() {
                        error = result.message;
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Text("Log In"),
                      onTap: () => widget.toggleView(),
                    ),
                    InkWell(
                      child: Text("Mot de passe oublié"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              error != ""
                  ? Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.red,
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
