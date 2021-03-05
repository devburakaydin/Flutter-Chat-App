import 'package:chat_app/models/kullanici.dart';

abstract class DbBase {
  Future<bool> saveUser(Kullanici kullanici);

  Future<Kullanici> readUser(String userID);

  Future<bool> emailSearch(String email);
  Future<bool> userNameSearch(String userName);
  Future<bool> userNameUpdate(String userName, String userID);
}
