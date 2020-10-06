import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/components/pleaseLogin.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/services/authentication_service.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

import '../../app.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profilePage';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);
    return user != null
        ? Scaffold(
            drawer: CustomDrawer(),
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text("LOUIS-MARIE", style: TextStyle(color: Colors.grey)),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.red),
                  onPressed: () async {
                    await AuthenticationService().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => App()),
                    );
                  },
                )
              ],
            ),
          )
        : Scaffold(
            drawer: CustomDrawer(),
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text("MY PROFILE", style: TextStyle(color: Colors.grey)),
              centerTitle: true,
            ),
            body: PleaseLoginComponent(text: "to show your profile."),
          );
  }
}
