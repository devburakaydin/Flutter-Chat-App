import 'dart:io';
import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/models/sohbet.dart';
//import 'package:chat_app/services/bildirim_gönderme_servis.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firebase_storage_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  //BildirimGondermeServis _bildirimGondermeServis = locator<BildirimGondermeServis>();
  List<Kullanici> tumKullanicilar = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  Future<Kullanici> currentUser() async {
    Kullanici _kullanici = await _firebaseAuthService.currentUser();
    if (_kullanici != null) {
      return await _firebaseDbService.readUser(_kullanici.userID);
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<bool> emailSearch(String email) async {
    return await _firebaseDbService.emailSearch(email);
  }

  Future<bool> userNameSearch(String userName) async {
    return await _firebaseDbService.userNameSearch(userName);
  }

  Future<bool> userNameUpdate(String userName, String userID) async {
    return await _firebaseDbService.userNameUpdate(userName, userID);
  }

  Future<Kullanici> signInWithGoogle() async {
    Kullanici _kullanici = await _firebaseAuthService.signInWithGoogle();

    if (_kullanici != null) {
      if (await _firebaseDbService.saveUser(_kullanici)) {
        return await _firebaseDbService.readUser(_kullanici.userID);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Kullanici> signInWithEmailAndPassword(String email, String sifre) async {
    Kullanici _kullanici = await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);
    if (_kullanici != null) {
      return await _firebaseDbService.readUser(_kullanici.userID);
    } else {
      return null;
    }
  }

  Future<Kullanici> createUserWithEmailAndPassword(String email, String sifre) async {
    Kullanici _kullanici = await _firebaseAuthService.createUserWithEmailAndPassword(email, sifre);
    if (_kullanici != null) {
      bool sonuc = await _firebaseDbService.saveUser(_kullanici);
      if (sonuc == true) {
        return await _firebaseDbService.readUser(_kullanici.userID);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String> uploadFile(String userID, String fileType, File yuklenecekDosya) async {
    String sonuc = await _firebaseStorageService.uploadFile(userID, fileType, yuklenecekDosya);
    if (sonuc != null) {
      bool durum = await _firebaseDbService.profilUrlUpload(userID, sonuc);
      if (durum) {
        return sonuc;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID) {
    return _firebaseDbService.getMessages(currentUserID, konusulanUserID);
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, Kullanici currentUser) async {
    return await _firebaseDbService.saveMessage(kaydedilecekMesaj);

    /*
    if (dbYazmaSonuc) {
      var token = "";
      if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
        token = kullaniciToken[kaydedilecekMesaj.kime];
      } else {
        token = await _firebaseDbService.tokenGetir(kaydedilecekMesaj.kime);
        if (token != null) kullaniciToken[kaydedilecekMesaj.kime] = token;
      }

      if (token != null) await _bildirimGondermeServis.bildirimGonder(kaydedilecekMesaj, currentUser, token);

      return true;
    } else {
      return false;
    }
    */
  }

  Kullanici listedeUserBul(String userID) {
    for (int i = 0; i < tumKullanicilar.length; i++) {
      if (tumKullanicilar[i].userID == userID) {
        return tumKullanicilar[i];
      }
    }

    return null;
  }

  void timeagoHesapla(Sohbet oankiKonusma, DateTime _zaman) {
    oankiKonusma.sonOkunmaZamani = _zaman;
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    oankiKonusma.aradakiFark = timeago.format(_zaman.subtract(_zaman.difference(oankiKonusma.olusturulmaTarihi.toDate())), locale: "tr");
  }

  Future<List<Kullanici>> getUserWithSayfalama(Kullanici enSonGelenUser, int getirilecekUserSayisi) async {
    List<Kullanici> _userList = await _firebaseDbService.getUserWithSayfalama(enSonGelenUser, getirilecekUserSayisi);
    tumKullanicilar.addAll(_userList);
    return _userList;
  }

  Future<List<Mesaj>> getMessageWithPagination(
      String currentUserID, String sohbetEdilenUserID, Mesaj _enSonGetirilenMesaj, int sayfaBasinaGonderiSayisi) async {
    return await _firebaseDbService.getMessageWithPagination(
        currentUserID, sohbetEdilenUserID, _enSonGetirilenMesaj, sayfaBasinaGonderiSayisi);
  }

  Future<bool> userUpdate(String veribaslik, String userID, String veri) async {
    return await _firebaseDbService.userUpdate(veribaslik, userID, veri);
  }

  Future<List<Sohbet>> getAllSohbetler(String userID) async {
    DateTime _zaman = await _firebaseDbService.saatiGoster(userID);
    var sohbetListesi = await _firebaseDbService.getAllSohbetler(userID);

    for (var oankiKonusma in sohbetListesi) {
      var userListesindekiKullanici = listedeUserBul(oankiKonusma.kimleKonusuyor);

      if (userListesindekiKullanici != null) {
        //print("VERILER LOCAL CACHEDEN OKUNDU");
        oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
        oankiKonusma.konusulanUserProfilURL = userListesindekiKullanici.profilURL;
        oankiKonusma.name = userListesindekiKullanici.name;
      } else {
        //print("VERILER VERITABANINDAN OKUNDU");

        var _veritabanindanOkunanUser = await _firebaseDbService.readUser(oankiKonusma.kimleKonusuyor);
        oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
        oankiKonusma.konusulanUserProfilURL = _veritabanindanOkunanUser.profilURL;
        oankiKonusma.name = _veritabanindanOkunanUser.name;
      }

      timeagoHesapla(oankiKonusma, _zaman);
    }

    return sohbetListesi;
  }
}
