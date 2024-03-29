import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/models/workout.dart';
import 'authentication_service.dart';
import 'database_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userUid;

  DatabaseService({this.userUid}) : assert(userUid != null, 'Cannot create DatabaseService with null user uid');

  final _usersDataCollection = FirebaseFirestore.instance.collection(DatabasePath.usersData());
  final _workoutsCollection = FirebaseFirestore.instance.collection(DatabasePath.workouts());

  // USERS
  Stream<FullUser> get fullUser {
    try {
      if (this.userUid != "") {
        return AuthenticationService().userFirebase.asyncExpand((u) => _userData.map((uData) => FullUser(userFirebase: u, userData: uData)));
      } else {
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<UserData> get _userData => _usersDataCollection.doc(userUid).snapshots().map((DocumentSnapshot userData) {
        try {
          return UserData.fromJson(userData.id, userData.data());
        } catch (error) {
          print(error.toString());
          return null;
        }
      });

  Future<void> insertUserData(UserData userData) => _usersDataCollection.doc(userUid).set(userData.toJson());

  Future<void> updateUserData(UserData userData) => _usersDataCollection.doc(userUid).set(userData.toJson());

  Future<void> deleteUserData() => _usersDataCollection.doc(userUid).delete();

  // WORKOUTS
  Stream<List<Workout>> get workouts => _workoutsCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) {
        return Workout.fromJson(doc.id, doc.data());
      }).toList());

  Stream<List<Workout>> get userWorkouts => _workoutsCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) {
        if (doc.data()["creatorUid"] == this.userUid) {
          return Workout.fromJson(doc.id, doc.data());
        }
      }).toList());

  Future<void> insertWorkout(Workout workout) => _workoutsCollection.doc(workout.uid).set(workout.toJson());

  Future<void> updateWorkout(Workout workout) => _workoutsCollection.doc(workout.uid).update(workout.toJson());

  Future<void> deleteWorkout(Workout workout) => _workoutsCollection.doc(workout.uid).delete();
}
