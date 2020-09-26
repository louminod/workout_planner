import 'package:flutter/material.dart';
import 'package:workout_planner/src/services/authentication_service.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profilePage';

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<FullUser>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("LOUIS-MARIE", style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.red,
          child: Text("LOGOUT", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            await AuthenticationService().signOut(context);
          },
        ),
      ),
    );
  }
}
