import 'package:shared_preferences/shared_preferences.dart';
import 'package:fixnum/fixnum.dart';

class Utils {
  static const hmcScheme = 'hmc://';

  static String fixHarmonyContentUrl(String link) {
    var removedScheme = link.replaceAll(hmcScheme, '');
    var parts = removedScheme.split('/');
    var host = parts[0];
    var contentId = parts[1];
    return 'https://$host/_harmony/media/download/$contentId/';
  }

  static String buildAvatarUrl(Uri server, String avatarId) {
    return '${server.scheme}://${server.host}:${server.port.toString()}/_harmony/media/download/$avatarId/';
  }

  static String formatDateTime(int unixtime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(unixtime);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    final checkDate = DateTime(date.year, date.month, date.day);
    if (checkDate == today) {
      return 'Today at $hours:$minutes';
    }
    else if (checkDate == yesterday) {
      return 'Yesterday at $hours:$minutes';
    }
    else {
      return '$month/$day/${date.year}';
    }
  }

}

class PersistentStorage {
  String? host;
  String? token;
  Int64? userId;

  static Future<PersistentStorage> get() async {
    final prefs = await SharedPreferences.getInstance();
    
    var inst = PersistentStorage();

    inst.host = prefs.getString("host");
    inst.token = prefs.getString("token");
    var userId = prefs.getInt("userId");
    if (userId != null) {
      inst.userId = Int64(userId);
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
    if (userId != null) prefs.setInt("userId", userId!.toInt());
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("host");
    prefs.remove("token");
    prefs.remove("userId");
  }
}