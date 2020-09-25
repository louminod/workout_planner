import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/pages/connection/connection.dart';
import 'package:workout_planner/src/pages/workout/references/workoutState.dart';
import 'package:workout_planner/src/pages/workout/workoutCreate.dart';
import 'package:workout_planner/src/services/database_service.dart';
import 'package:workout_planner/src/tools/converters.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

class WorkoutPage extends StatelessWidget {
  static const String routeName = '/workoutPage';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);

    List<Workout> userWorkouts;
    List<TimelineModel> items;

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
                  userWorkouts = [];
                  userWorkouts = userWorkoutsSnapshot.data;
                  items = [];
                  userWorkouts.forEach((workout) {
                    items.add(workoutCard(workout));
                  });
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
                    child: Text(userWorkoutsSnapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please "),
                  RaisedButton(
                    child: Text("Login", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectionPage()),
                      );
                    },
                    color: Colors.black,
                  ),
                  Text(" to show or create workouts."),
                ],
              ),
            ),
      floatingActionButton: user != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutCreatePage(user: user)),
                );
              },
              label: Text('Create'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.black,
            )
          : null,
    );
  }

  TimelineModel workoutCard(Workout workout) {
    Icon statusIcon;

    switch (workout.status) {
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
              title: Text(workout.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(Converters.dateTimeToString(workout.date), style: TextStyle(color: Colors.grey)),
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
                    itemCount: workout.categories.length,
                    itemBuilder: (context, index) {
                      return categoryItem(workout.categories[index].toString().split(".")[1]);
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
                  Text("${workout.nbExercises} exercices", style: TextStyle(fontSize: 17, color: Colors.grey)),
                  Text("${workout.nbSeries} séries", style: TextStyle(fontSize: 17, color: Colors.grey)),
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
                percent: workout.statusPercent / 100,
                center: Text("${workout.statusPercent}.0%", style: TextStyle(color: Colors.white)),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: workout.statusPercent == 100 ? Colors.greenAccent : Colors.black,
              ),
            ),
            ButtonBar(
              children: <Widget>[
                statusIcon,
                RaisedButton(
                  color: Colors.black,
                  elevation: 3,
                  child: workout.statusPercent == 0 ? Text("RUN") : workout.statusPercent == 100 ? Text("FINISHED") : Text("CONTINUE"),
                  onPressed: workout.statusPercent == 100 ? null : () {},
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
