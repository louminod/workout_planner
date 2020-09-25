import 'package:firebase_auth/firebase_auth.dart';

class FullUser {
  final UserData userData;
  final User userFirebase;

  FullUser({this.userFirebase, this.userData});
}

class UserData {
  String uid;
  String name;

  UserData({this.uid, this.name});

  UserData.fromJson(String uid, Map<String, dynamic> parsedJson) {
    this.uid = uid;
    this.name = parsedJson["name"];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
    };
  }
}
