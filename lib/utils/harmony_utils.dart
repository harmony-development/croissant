
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
      return '$month/$day/${date.year} $hours:$minutes';
    }
  }

}
