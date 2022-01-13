import 'package:hive_flutter/hive_flutter.dart';

part 'hive.g.dart';

class HiveUtils {
  static Future<void> superInit() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CredentialsAdapter());
    await Hive.openBox('box');
  }
}

@HiveType(typeId: 0)
class Credentials extends HiveObject {
  @HiveField(0)
  String host;

  @HiveField(1)
  String token;

  @HiveField(2)
  int userId;

  Credentials(this.host, this.token, this.userId);
}