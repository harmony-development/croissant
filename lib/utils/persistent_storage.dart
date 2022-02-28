import 'package:fixnum/fixnum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  String? host;
  String? token;
  Int64? userId;

  static Future<PersistentStorage> get() async {
    final prefs = await SharedPreferences.getInstance();
    
    var inst = PersistentStorage();

    inst.host = prefs.getString("host");
    inst.token = prefs.getString("token");
    var userId = prefs.getString("userId");
    if (userId != null) {
      inst.userId = Int64.parseInt(userId);
    }

    return inst;
  }

  bool hasSession() {
    return host != null && token != null && userId != null;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    if (host != null) prefs.setString("host", host!);
    if (token != null) prefs.setString("token", token!);
    if (userId != null) prefs.setString("userId", userId!.toString());
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("host");
    prefs.remove("token");
    prefs.remove("userId");
  }
}