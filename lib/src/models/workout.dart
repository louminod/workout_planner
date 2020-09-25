import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_planner/src/pages/workout/references/workoutCategory.dart';
import 'package:workout_planner/src/pages/workout/references/workoutState.dart';
import 'package:workout_planner/src/tools/converters.dart';

class Workout {
  String uid;
  String creatorUid;
  String name;
  List<WorkoutCategory> categories;
  DateTime date;
  int nbSeries;
  int nbExercises;
  WorkoutStatus status;
  int statusPercent;

  Workout({this.uid, this.creatorUid, this.name, this.categories, this.date, this.nbSeries, this.nbExercises, this.status, this.statusPercent});

  Workout.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.creatorUid = parsedJson["creatorUid"];
    this.name = parsedJson["name"];
    this.categories = [];
    (parsedJson["categories"] as String).replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "").split(",").forEach((element) {
      this.categories.add(Converters.stringToWorkoutCategory(element));
    });
    this.date = (parsedJson["dateWorkout"] as Timestamp).toDate();
    this.nbSeries = int.parse(parsedJson["nbSeries"]);
    this.nbExercises = int.parse(parsedJson["nbExercices"]);
    this.status = Converters.stringToWorkoutStatus(parsedJson["status"]);
    this.statusPercent = int.parse(parsedJson["statusPercent"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'categories': this.categories.toString(),
      'creatorUid': this.creatorUid,
      'dateWorkout': this.date,
      'nbSeries': this.nbSeries.toString(),
      'nbExercices': this.nbExercises.toString(),
      'status': this.status.toString(),
      'statusPercent': this.statusPercent.toString(),
    };
  }
}
