import 'package:flutter/cupertino.dart';

class User {
  final String uid;

  User({required this.uid});
}

class UserData {
  final String id;
  final String username;
  final String full_name;
  final String avatar_url;

  UserData({ required this.username, required this.id, required this.full_name, required this.avatar_url });
}