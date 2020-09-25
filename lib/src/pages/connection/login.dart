import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      hintText: 'Your mail address.',
                      labelText: 'Email',
                    ),
                    validator: (String value) {
                      return !value.contains('@') ? "It's not a mail" : null;
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Your password',
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (String value) {
                      return value.length == 0 && value == "" ? 'The password is empty' : null;
                    },
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.blueAccent,
                    child: Text('Connexion'),
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
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
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
                ],
              ),
            ),
          );
  }
}
