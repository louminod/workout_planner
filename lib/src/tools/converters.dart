import 'package:workout_planner/src/pages/workout/references/workoutCategory.dart';
import 'package:workout_planner/src/pages/workout/references/workoutState.dart';

abstract class Converters {
  static WorkoutStatus stringToWorkoutStatus(String string) {
    WorkoutStatus result;
    for (WorkoutStatus workoutStatus in WorkoutStatus.values) {
      if (workoutStatus.toString() == string) {
        result = workoutStatus;
      }
    }
    return result;
  }

  static WorkoutCategory stringToWorkoutCategory(String string) {
    WorkoutCategory result;
    for (WorkoutCategory workoutCategory in WorkoutCategory.values) {
      if (workoutCategory.toString() == string) {
        result = workoutCategory;
      }
    }
    return result;
  }

  static String dateTimeToString(DateTime dateTime) {
    return "${dateTime.day >= 10 ? dateTime.day : '0${dateTime.day}'}/${dateTime.month >= 10 ? dateTime.month : '0${dateTime.month}'}/${dateTime.year}";
  }
}
