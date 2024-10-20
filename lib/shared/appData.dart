import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  UserInfo user = UserInfo();
}

class UserInfo {
  String name = "";
  String phone = "";
  String image = "";
  String address = "";
}
