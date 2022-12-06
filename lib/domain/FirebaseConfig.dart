import 'dart:io';

import 'package:flutter/material.dart';
import 'package:h_f/screens/UserInformation.dart';
import 'package:h_f/screens/WebViewPage.dart';
import 'package:h_f/services/classes.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseConfig {}

Future<Linker> getLink(String keyLink) async {
  var pref = await SharedPreferences.getInstance();
  var res = Linker(link: pref.getString(keyLink) as String);
  //print(pref.getString(keyLink).toString());
  //print(str);
  return res;

  //print(res);
}

Future link(var res) async {
  String str = await res;
  return res.toString();
}

Future setLink(String keyLink, String link) async {
  var pref = await SharedPreferences.getInstance();
  return pref.setString(keyLink, link);
}
