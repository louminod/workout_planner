import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/services/authentication_service.dart';

import '../../app.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;

  const LoginPage({Key key, this.toggleView}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    SizedBox(height: 40),
                    RaisedButton(
                      color: Colors.black,
                      child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });

                          dynamic result = await AuthenticationService().signInWithEmailAndPassword(email.replaceAll(' ', ''), password);

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
                            child: Text("Sign In"),
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
