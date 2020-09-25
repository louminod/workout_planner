import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

class RunningPage extends StatelessWidget {
  static const String routeName = '/runningPage';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("RUNNING", style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Run'),
        icon: Icon(Icons.directions_run),
        backgroundColor: Colors.black,
      ),
    );
  }
}
