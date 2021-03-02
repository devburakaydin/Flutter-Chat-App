import 'package:chat_app/models/kullanici.dart';

abstract class DbBase {
  Future<bool> saveUser(Kullanici kullanici);

  Future<Kullanici> readUser(String userID);
}
