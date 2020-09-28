import 'package:flutter/material.dart';

import '../pages/connection/connection.dart';

class PleaseLoginComponent extends StatelessWidget {
  final String text;

  const PleaseLoginComponent({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Please "),
          RaisedButton(
            child: Text("Login", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConnectionPage()),
              );
            },
            color: Colors.black,
          ),
          Text(" " + text),
        ],
      ),
    );
  }
}
