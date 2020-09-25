import 'package:workout_planner/src/references/workoutState.dart';

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
}
