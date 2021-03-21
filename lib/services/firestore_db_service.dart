import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/models/sohbet.dart';
import 'package:chat_app/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService implements DbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Kullanici kullanici) async {
    var sonuc = await _firestore.collection("users").doc(kullanici.userID).get();
    if (sonuc.data() == null) {
      await _firestore.collection("users").doc(kullanici.userID).set(kullanici.toMap());
      DocumentSnapshot documentSnapshot = await _firestore.collection("users").doc(kullanici.userID).get();
      if (documentSnapshot.data().isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
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
    if (Kullanici.fromMap(snapshot.data()).profilURL == url) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID) {
    var snapshot = _firestore
        .collection("konusmalar")
        .doc(currentUserID + "--" + konusulanUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapshot.map((mesajListesi) => mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firestore.collection("konusmalar").doc().id;
    var _myDocumentID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID = kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firestore.collection("konusmalar").doc(_myDocumentID).collection("mesajlar").doc(_mesajID).set(_kaydedilecekMesajMapYapisi);

    await _firestore.collection("konusmalar").doc(_myDocumentID).set({
      "konusmaSahibi": kaydedilecekMesaj.kimden,
      "kimleKonusuyor": kaydedilecekMesaj.kime,
      "sonYollananMesaj": kaydedilecekMesaj.mesaj,
      "konusmaGoruldu": false,
      "olusturulmaTarihi": FieldValue.serverTimestamp(),
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
      "konusmaSahibi": kaydedilecekMesaj.kime,
      "kimleKonusuyor": kaydedilecekMesaj.kimden,
      "sonYollananMesaj": kaydedilecekMesaj.mesaj,
      "konusmaGoruldu": false,
      "olusturulmaTarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Sohbet>> getAllSohbetler(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusmaSahibi", isEqualTo: userID)
        .orderBy("olusturulmaTarihi", descending: true)
        .get();

    List<Sohbet> sohbetler = [];

    for (QueryDocumentSnapshot tekSohbet in querySnapshot.docs) {
      sohbetler.add(Sohbet.fromMap(tekSohbet.data()));
    }
    return sohbetler;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firestore.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });

    var okunanMap = await _firestore.collection("server").doc(userID).get();
    Timestamp okunanTarih = okunanMap.data()["saat"];
    return okunanTarih.toDate();
  }

  @override
  Future<List<Kullanici>> getUserWithSayfalama(Kullanici enSonGelenUser, int gelecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Kullanici> _tumKullanicilar = [];

    if (enSonGelenUser == null) {
      _querySnapshot = await _firestore.collection("users").orderBy("userName").limit(gelecekElemanSayisi).get();
    } else {
      _querySnapshot =
          await _firestore.collection("users").orderBy("userName").startAfter([enSonGelenUser.userName]).limit(gelecekElemanSayisi).get();
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snapshot in _querySnapshot.docs) {
      _tumKullanicilar.add(Kullanici.fromMap(snapshot.data()));
    }
    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessageWithPagination(
      String currentUserID, String sohbetEdilenUserID, Mesaj enSonGetirilenMesaj, int sayfaBasinaGonderiSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj> _tumMesajlar = [];

    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await _firestore
          .collection("konusmalar")
          .doc(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(sayfaBasinaGonderiSayisi)
          .get();
    } else {
      _querySnapshot = await _firestore
          .collection("konusmalar")
          .doc(currentUserID + "--" + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(sayfaBasinaGonderiSayisi)
          .get();
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snapshot in _querySnapshot.docs) {
      _tumMesajlar.add(Mesaj.fromMap(snapshot.data()));
    }
    return _tumMesajlar;
  }

  Future<String> tokenGetir(String kime) async {
    DocumentSnapshot _token = await _firestore.doc("tokens/" + kime).get();
    if (_token != null)
      return _token.data()["token"];
    else
      return null;
  }

  Future<bool> userUpdate(String veribaslik, String userID, String veri) async {
    await _firestore.collection("users").doc(userID).update({veribaslik: veri});
    DocumentSnapshot snapshot = await _firestore.collection("users").doc(userID).get();
    Kullanici kullanici = Kullanici.fromMap(snapshot.data());

    if (veribaslik == "name") {
      if (kullanici.name == veri) {
        return true;
      } else {
        return false;
      }
    } else if (veribaslik == "userName") {
      if (kullanici.userName == veri) {
        return true;
      } else {
        return false;
      }
    } else if (veribaslik == "durum") {
      if (kullanici.durum == veri) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
