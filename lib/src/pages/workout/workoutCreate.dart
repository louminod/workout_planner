import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/pages/loading.dart';
import 'package:workout_planner/src/pages/workout/references/workoutCategory.dart';
import 'package:workout_planner/src/pages/workout/references/workoutState.dart';
import 'package:workout_planner/src/services/database_service.dart';

class WorkoutCreatePage extends StatefulWidget {
  final FullUser user;

  const WorkoutCreatePage({Key key, this.user}) : super(key: key);

  @override
  _WorkoutCreatePageState createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
  bool loading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return this.loading
        ? LoadingPage()
        : Scaffold(
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text("CREATE A WORKOUT", style: TextStyle(color: Colors.grey)),
              centerTitle: true,
            ),
            body: errorMessage != ""
                ? Center(
                    child: Text(errorMessage, style: TextStyle(color: Colors.red)),
                  )
                : null,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                Workout workout = new Workout(
                  name: "Test",
                  categories: [
                    WorkoutCategory.CARDIO,
                    WorkoutCategory.LEGS,
                  ],
                  creatorUid: widget.user.userFirebase.uid,
                  date: DateTime.now(),
                  nbExercises: 10,
                  nbSeries: 4,
                  status: WorkoutStatus.CREATED,
                  statusPercent: 0,
                );
                try {
                  await DatabaseService(userUid: widget.user.userFirebase.uid).insertWorkout(workout);
                  Navigator.pop(context);
                } catch (error) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                }
                setState(() {
                  loading = false;
                });
              },
              label: Text('SAVE'),
              icon: Icon(Icons.whatshot),
              backgroundColor: Colors.black,
            ),
          );
  }
}
