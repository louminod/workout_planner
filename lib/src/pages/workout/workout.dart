import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/pages/workout/workoutCreate.dart';
import 'package:workout_planner/src/references/workoutState.dart';
import 'package:workout_planner/src/services/database_service.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

class WorkoutPage extends StatelessWidget {
  static const String routeName = '/workoutPage';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);

    List<Workout> userWorkouts = [];

    final List<TimelineModel> items = [
      workoutCard("cardio", "12 septembre 2020", 14, 3, ["RUN", "CROSSFIT", "BIKE", "STRETCH"], WorkoutStatus.FINISHED, 100),
      workoutCard("legs", "17 septembre 2020", 7, 4, ["RUN", "MUSCU", "COURSES"], WorkoutStatus.CREATED, 60),
    ];

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("MY WORKOUTS", style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: user != null
          ? StreamBuilder(
              stream: DatabaseService(userUid: user.userFirebase.uid).userWorkouts,
              builder: (context, AsyncSnapshot<List<Workout>> userWorkoutsSnapshot) {
                if (userWorkoutsSnapshot.hasData) {
                  userWorkouts = userWorkoutsSnapshot.data;
                  return userWorkouts.length > 0
                      ? Container(
                          margin: EdgeInsets.only(top: 10, left: 15),
                          padding: EdgeInsets.only(bottom: 40),
                          child: Timeline(
                            children: items,
                            position: TimelinePosition.Left,
                          ),
                        )
                      : Center(
                          child: Text("No workouts created yet"),
                        );
                } else if (userWorkoutsSnapshot.hasError) {
                  return Center(
                    child: Text(userWorkoutsSnapshot.error),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: Text("Please login to show your workouts"),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutCreatePage()),
          );
        },
        label: Text('Create'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }

  TimelineModel workoutCard(
      String title, String date, int nbExercises, int nbSeries, List<String> categories, WorkoutStatus status, int completedPercent) {
    Icon statusIcon;

    switch (status) {
      case WorkoutStatus.CREATED:
        statusIcon = Icon(Icons.assistant, color: Colors.cyan);
        break;
      case WorkoutStatus.FINISHED:
        statusIcon = Icon(Icons.check, color: Colors.green);
        break;
      case WorkoutStatus.CANCELED:
        statusIcon = Icon(Icons.cancel, color: Colors.red);
        break;
    }

    return TimelineModel(
      Card(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        elevation: 3,
        child: Column(
          children: [
            ListTile(
              title: Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(date, style: TextStyle(color: Colors.grey)),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(right: 10),
                height: 27,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return categoryItem(categories[index]);
                    },
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("15:00", style: TextStyle(fontSize: 17, color: Colors.grey)),
                  Text("$nbExercises exercices", style: TextStyle(fontSize: 17, color: Colors.grey)),
                  Text("$nbSeries séries", style: TextStyle(fontSize: 17, color: Colors.grey)),
                ],
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                animationDuration: 1000,
                percent: completedPercent / 100,
                center: Text("$completedPercent.0%", style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: completedPercent == 100 ? Colors.greenAccent : Colors.black,
              ),
            ),
            ButtonBar(
              children: <Widget>[
                statusIcon,
                RaisedButton(
                  color: Colors.black,
                  elevation: 3,
                  child: completedPercent == 0 ? Text("RUN") : completedPercent == 100 ? Text("FINISHED") : Text("CONTINUE"),
                  onPressed: completedPercent == 100 ? null : () {},
                )
              ],
            ),
          ],
        ),
      ),
      position: TimelineItemPosition.right,
      iconBackground: Colors.black,
      icon: Icon(Icons.blur_on, color: Colors.white),
    );
  }

  Container categoryItem(String name) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.blueAccent,
      ),
      child: Text(name.toUpperCase(), style: TextStyle(color: Colors.grey[200])),
    );
  }
}
