import 'package:h_f/domain/services/classes.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseConfig {}

Future<Linker> getLink(String keyLink) async {
  var pref = await SharedPreferences.getInstance();
  var res = Linker(link: pref.getString(keyLink) as String);

  return res;
}

Future link(var res) async {
  return res.toString();
}

Future setLink(String keyLink, String link) async {
  var pref = await SharedPreferences.getInstance();
  return pref.setString(keyLink, link);
}
