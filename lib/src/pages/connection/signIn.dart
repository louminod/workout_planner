import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/services/authentication_service.dart';

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

  String email = '';
  String password = '';
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                return value == "" ? 'The password is empty' : null;
              },
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.vpn_key),
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
              ),
              obscureText: true,
              validator: (String value) {
                return value == "" || value != password ? 'The password is empty or different' : null;
              },
              onChanged: (val) {
                setState(() => password2 = val);
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Colors.blueAccent,
              child: Text('Create'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    loading = true;
                  });

                  UserData userData = UserData();

                  dynamic result = await AuthenticationService().createUserWithEmailAndPassword(userData, email.replaceAll(' ', ''), password);

                  if (result is FullUser) {
                    setState(() {
                      loading = false;
                    });
                  } else {
                    setState(() {
                      error = result.message;
                      loading = false;
                    });
                  }

                  setState(() {
                    loading = false;
                  });
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
                    child: Text("Login"),
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
