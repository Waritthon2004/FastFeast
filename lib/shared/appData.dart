import 'dart:async';

import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  StreamSubscription? listener;
  StreamSubscription? listener2;

  UserInfo user = UserInfo();
}

class UserInfo {
  String name = "";
  String phone = "";
  String image = "";
  String docStatus = "";
  String address = "";
  String id = "";
  List doc = [];
  int role = 0;
}
