import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome ", style: TextStyle(fontSize: 20)),
                  Text(user != null ? user.userData.name : "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(" !", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            height: 200,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 160.0,
                    child: Card(
                        elevation: 5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/images/crossfit.png",width: 100),
                              Text("WORKOUTS"),
                            ],
                          ),
                        )),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, PageRoutes.workout);
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 160.0,
                    child: Card(
                        elevation: 5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/images/profile_icon.png",width: 100),
                              Text("ME"),
                            ],
                          ),
                        )),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, PageRoutes.profile);
                  },
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
