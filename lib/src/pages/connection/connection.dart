import 'package:flutter/material.dart';
import 'package:workout_planner/src/pages/connection/login.dart';
import 'package:workout_planner/src/pages/connection/signIn.dart';

class ConnectionPage extends StatefulWidget {
  static const String routeName = '/connectionPage';

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool showLogin;

  @override
  void initState() {
    super.initState();
    showLogin = true;
  }

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: showLogin ? LoginPage(toggleView: toggleView) : SignInPage(toggleView: toggleView),
    );
  }
}
