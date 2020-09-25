import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/widgets/customDrawer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("HOME", style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            child: ListTile(
              title: Row(
                children: [
                  Text("Welcome ", style: TextStyle(fontSize: 20)),
                  Text(user != null ? user.userData.name : "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(" !", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
