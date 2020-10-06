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
  final _controller = ScrollController();

  bool loading = false;
  String errorMessage = "";

  List lstExercises;

  @override
  void initState() {
    super.initState();
    lstExercises = [];
  }

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
                : workoutCreator(),
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
                  statusPercent: 20,
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

  Widget workoutCreator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DragTarget(
          builder: (context, List<String> candidateData, rejectedData) {
            return Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: lstExercises.length,
                controller: _controller,
                padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width / 2)),
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 50, horizontal: 5),
                    elevation: 3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          lstExercises[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            setState(() {
              lstExercises.add(data);
            });
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          },
        ),
        SizedBox(height: 50),
        Center(
          child: Column(
            children: [
              Draggable(
                data: 'push_up',
                child: Card(
                  elevation: 3,
                  child: Image.asset("assets/gifs/push_up.gif", height: 150, width: 150),
                ),
                feedback: Card(
                  elevation: 7,
                  child: Image.asset("assets/gifs/push_up.gif", height: 130, width: 130),
                ),
                childWhenDragging: Container(),
              ),
              Draggable(
                data: 'run',
                child: Card(
                  elevation: 3,
                  child: Image.asset("assets/gifs/run.gif", height: 150, width: 150),
                ),
                feedback: Card(
                  elevation: 7,
                  child: Image.asset("assets/gifs/run.gif", height: 130, width: 130),
                ),
                childWhenDragging: Container(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
