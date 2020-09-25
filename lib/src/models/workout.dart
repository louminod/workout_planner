import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_planner/src/references/workoutState.dart';
import 'package:workout_planner/src/tools/converters.dart';

class Workout {
  String uid;
  String creatorUid;
  String name;
  DateTime date;
  int nbSeries;
  int nbExercices;
  WorkoutStatus status;
  int statusPercent;

  Workout({this.uid, this.creatorUid, this.name, this.date, this.nbSeries, this.nbExercices, this.status, this.statusPercent});

  Workout.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.name = parsedJson["name"];
    this.creatorUid = parsedJson["creatorUid"];
    this.date = (parsedJson["dateWorkout"] as Timestamp).toDate();
    this.nbSeries = int.parse(parsedJson["nbSeries"]);
    this.nbExercices = int.parse(parsedJson["nbExercices"]);
    this.status = Converters.stringToWorkoutStatus(parsedJson["status"]);
    this.statusPercent = int.parse(parsedJson["statusPercent"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'creatorUid': this.creatorUid,
      'dateWorkout': this.date,
      'nbSeries': this.nbSeries.toString(),
      'nbExercices': this.nbExercices.toString(),
      'status': this.status.toString(),
      'statusPercent': this.statusPercent.toString(),
    };
  }
}
