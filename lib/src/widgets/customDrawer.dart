import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/src/models/fullUser.dart';
import 'package:workout_planner/src/pages/connection/connection.dart';
import 'package:workout_planner/src/routes/pageRoutes.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FullUser>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: user != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, PageRoutes.profile);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/images/profile.jpg"),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(user.userData.name.toUpperCase(), style: TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: RaisedButton.icon(
                      color: Colors.black,
                      icon: Icon(Icons.account_circle, color: Colors.white),
                      label: Text("Me connecter", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConnectionPage()),
                        );
                      },
                    ),
                  ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
          ListTile(
            title: Text('HOME'),
            onTap: () {
              Navigator.pushReplacementNamed(context, PageRoutes.home);
            },
          ),
          Divider(),
          ListTile(
            title: Text('WORKOUT'),
            onTap: () {
              Navigator.pushReplacementNamed(context, PageRoutes.workout);
            },
          ),
        ],
      ),
    );
  }
}
