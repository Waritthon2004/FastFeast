import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  StreamSubscription? listener;
  StreamSubscription? listener2;
StreamSubscription? listener3;
  UserInfo user = UserInfo();
}

class UserInfo {
  String name = "";
  String phone = "";
  String image = "";
  String docStatus = "";
  String address = "";
  String id = "";
  late GeoPoint location;
  List doc = [];
  int role = 0;

}
