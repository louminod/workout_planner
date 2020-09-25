import 'package:workout_planner/src/models/fullUser.dart';
import 'authentication_service.dart';
import 'database_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userUid;

  DatabaseService({this.userUid}) : assert(userUid != null, 'Cannot create DatabaseService with null user uid');

  final _usersDataCollection = FirebaseFirestore.instance.collection(DatabasePath.usersData());

  Stream<FullUser> get fullUser {
    if (this.userUid != "") {
      return AuthenticationService().userFirebase.asyncExpand((u) => _userData.map((uData) => FullUser(userFirebase: u, userData: uData)));
    }
  }

  Stream<UserData> get _userData => _usersDataCollection.doc(userUid).snapshots().map((DocumentSnapshot userData) {
        return UserData.fromJson(userData.id, userData.data());
      });

  Future<void> insertUserData(UserData userData) => _usersDataCollection.doc(userUid).set(userData.toJson());

  Future<void> updateUserData(UserData userData) => _usersDataCollection.doc(userUid).set(userData.toJson());

  Future<void> deleteUserData() => _usersDataCollection.doc(userUid).delete();
}
