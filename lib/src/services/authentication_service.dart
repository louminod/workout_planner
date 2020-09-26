import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_planner/src/models/fullUser.dart';

import 'database_service.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get userFirebase {
    return _firebaseAuth.authStateChanges();
  }

  Future<dynamic> createUserWithEmailAndPassword(UserData userData, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      try {
        await DatabaseService(userUid: user.uid).insertUserData(userData);
        // await AuthenticationService().sendEmailVerificationLink();
      } catch (error) {
        return error;
      }
      return FullUser(userFirebase: userCredential.user);
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return FullUser(userFirebase: userCredential.user);
    } catch (error) {
      return error;
    }
  }

  Future<void> sendEmailVerificationLink() {
    return _firebaseAuth.currentUser.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
