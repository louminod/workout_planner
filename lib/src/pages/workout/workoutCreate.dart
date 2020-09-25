import 'package:flutter/material.dart';

class WorkoutCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("CREATE A WORKOUT", style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
    );
  }
}
