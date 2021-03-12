import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/models/sohbet.dart';

abstract class DbBase {
  Future<bool> saveUser(Kullanici kullanici);

  Future<Kullanici> readUser(String userID);

  Future<bool> emailSearch(String email);
  Future<bool> userNameSearch(String userName);
  Future<bool> userNameUpdate(String userName, String userID);
  Future<bool> profilUrlUpload(String userID, String url);

  Future<List<Kullanici>> getUserWithSayfalama(Kullanici enSonGelenUser, int gelecekElemanSayisi);
  Future<List<Sohbet>> getAllSohbetler(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime> saatiGoster(String userID);
}
