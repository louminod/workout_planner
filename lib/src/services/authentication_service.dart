import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_planner/src/models/fullUser.dart';

import '../app.dart';
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
        await AuthenticationService().sendEmailVerificationLink();
      } catch (error) {
        print(error);
      }

      return user;
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

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => App()),
    );
  }
}
