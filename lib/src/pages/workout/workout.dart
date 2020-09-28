import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'package:workout_planner/src/pages/connection/connection.dart';
import 'package:workout_planner/src/components/pleaseLogin.dart';
import 'package:workout_planner/src/pages/workout/references/workoutState.dart';
import 'package:workout_planner/src/pages/workout/workoutCreate.dart';
import 'package:workout_planner/src/pages/workout/workoutDetail.dart';
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
                    items.add(workoutCard(workout, context, user));
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
          : PleaseLoginComponent(text: "to show or create workouts."),
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

  TimelineModel workoutCard(Workout workout, BuildContext context, FullUser user) {
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
      Slidable(
        closeOnScroll: true,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          Container(
            height: 320,
            child: IconSlideAction(
              caption: 'Reset',
              color: Colors.white,
              icon: Icons.loop,
              onTap: () async {
                workout.statusPercent = 0;
                workout.status = WorkoutStatus.CREATED;
                await DatabaseService(userUid: user.userFirebase.uid).updateWorkout(workout);
                Fluttertoast.showToast(
                    msg: "Workout updated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.greenAccent,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
            ),
          ),
          Container(
            height: 320,
            child: IconSlideAction(
              caption: 'Complete',
              color: Colors.white,
              icon: Icons.check,
              onTap: () async {
                workout.statusPercent = 100;
                workout.status = WorkoutStatus.FINISHED;
                await DatabaseService(userUid: user.userFirebase.uid).updateWorkout(workout);
                Fluttertoast.showToast(
                    msg: "Workout updated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.greenAccent,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
            ),
          ),
          Container(
            height: 320,
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.white,
              icon: Icons.delete,
              onTap: () async {
                await DatabaseService(userUid: user.userFirebase.uid).deleteWorkout(workout);
                Fluttertoast.showToast(
                    msg: "Workout deleted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
            ),
          ),
        ],
        child: Card(
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
                  center: Text("${workout.statusPercent}.0%", style: TextStyle(color: workout.statusPercent < 38 ? Colors.black : Colors.white)),
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
                    child: workout.statusPercent == 0 ? Text("SEE") : workout.statusPercent == 100 ? Text("FINISHED") : Text("CONTINUE"),
                    onPressed: workout.statusPercent == 100
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WorkoutDetailPage(workout: workout, user: user)),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
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
