import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/models/sohbet.dart';
import 'package:chat_app/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService implements DbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Kullanici kullanici) async {
    await _firestore.collection("users").doc(kullanici.userID).set(kullanici.toMap());
    DocumentSnapshot documentSnapshot = await _firestore.collection("users").doc(kullanici.userID).get();
    if (documentSnapshot.data().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Kullanici> readUser(String userID) async {
    DocumentSnapshot _okunanUser = await _firestore.collection("users").doc(userID).get();
    if (_okunanUser.data().isNotEmpty) {
      return Kullanici.fromMap(_okunanUser.data());
    } else {
      return null;
    }
  }

  @override
  Future<bool> emailSearch(String email) async {
    var sonuc = await _firestore.collection("users").where("email", isEqualTo: email).get();
    if (sonuc.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> userNameSearch(String userName) async {
    var sonuc = await _firestore.collection("users").where("userName", isEqualTo: userName).get();
    if (sonuc.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> userNameUpdate(String userName, String userID) async {
    await _firestore.collection("users").doc(userID).update({"userName": userName});
    DocumentSnapshot snapshot = await _firestore.collection("users").doc(userID).get();

    if (Kullanici.fromMap(snapshot.data()).userName == userName) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> profilUrlUpload(String userID, String url) async {
    await _firestore.collection("users").doc(userID).update({"profilURL": url});
    DocumentSnapshot snapshot = await _firestore.collection("users").doc(userID).get();
    if (Kullanici.fromMap(snapshot.data()).profilURL != url) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Kullanici>> getAllUser() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    List<Kullanici> tumKullanicilar = [];

    for (QueryDocumentSnapshot tekUser in querySnapshot.docs) {
      tumKullanicilar.add(Kullanici.fromMap(tekUser.data()));
    }
    return tumKullanicilar;
  }

  @override
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID) {
    var snapshot = _firestore
        .collection("konusmalar")
        .doc(currentUserID + "--" + konusulanUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();
    return snapshot
        .map((mesajListesi) => mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firestore.collection("konusmalar").doc().id;
    var _myDocumentID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID = kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firestore
        .collection("konusmalar")
        .doc(_myDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    await _firestore.collection("konusmalar").doc(_myDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);
    _kaydedilecekMesajMapYapisi.update("konusmaSahibi", (deger) => kaydedilecekMesaj.kime);

    await _firestore
        .collection("konusmalar")
        .doc(_receiverDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    await _firestore.collection("konusmalar").doc(_receiverDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Sohbet>> getAllSohbetler(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    List<Sohbet> sohbetler = [];

    for (QueryDocumentSnapshot tekSohbet in querySnapshot.docs) {
      sohbetler.add(Sohbet.fromMap(tekSohbet.data()));
    }
    return sohbetler;
  }
}
