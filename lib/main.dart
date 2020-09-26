import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_planner/src/app.dart';
import 'package:workout_planner/src/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
