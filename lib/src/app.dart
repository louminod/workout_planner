import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/pages/connection/connection.dart';
import 'package:workout_planner/src/pages/home.dart';
import 'package:workout_planner/src/pages/profile.dart';
import 'package:workout_planner/src/pages/workout/workout.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';
import 'package:workout_planner/src/services/authentication_service.dart';
import 'package:workout_planner/src/services/database_service.dart';

import 'models/fullUser.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String userUid;

  @override
  void initState() {
    super.initState();
    userUid = "";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User>(
          stream: AuthenticationService().userFirebase,
          builder: (context, AsyncSnapshot<User> userFirebaseSnapshot) {
            if (userFirebaseSnapshot.hasData) {
              User user = userFirebaseSnapshot.data;
              userUid = user.uid;
            }
            return StreamProvider<FullUser>.value(
              value: DatabaseService(userUid: userUid).fullUser,
              child: HomePage(),
            );
          }),
      routes: {
        PageRoutes.home: (context) => StreamProvider<FullUser>.value(
              value: DatabaseService(userUid: userUid).fullUser,
              child: HomePage(),
            ),
        PageRoutes.workout: (context) => StreamProvider<FullUser>.value(
              value: DatabaseService(userUid: userUid).fullUser,
              child: WorkoutPage(),
            ),
        PageRoutes.profile: (context) => StreamProvider<FullUser>.value(
              value: DatabaseService(userUid: userUid).fullUser,
              child: ProfilePage(),
            ),
        PageRoutes.connection: (context) => StreamProvider<FullUser>.value(
              value: DatabaseService(userUid: userUid).fullUser,
              child: ConnectionPage(),
            ),
      },
    );
  }
}
