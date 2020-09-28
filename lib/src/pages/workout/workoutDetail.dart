import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';

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
     body: Center(
       child: RaisedButton(
         color: Colors.black,
         child: Text("BACK", style: TextStyle(color: Colors.white)),
         onPressed: () {
           Navigator.pushReplacementNamed(context, PageRoutes.workout);
         },
       ),
     ),
    );
  }
}
