import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';
import 'package:workout_planner/src/services/database_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Workout workout;
  final FullUser user;

  const WorkoutDetailPage({Key key, this.workout, this.user}) : super(key: key);

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(widget.workout.name, style: TextStyle(color: Colors.grey)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // set up the buttons
              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Confirm"),
                content: Text("Do you really want to delete this workout ?"),
                actions: [
                  FlatButton(
                    child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    color: Colors.black,
                    child: Text("DELETE", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await DatabaseService(userUid: widget.user.userFirebase.uid).deleteWorkout(widget.workout);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, PageRoutes.workout);
                    },
                  )
                ],
              );
              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          )
        ],
      ),
    );
  }
}
