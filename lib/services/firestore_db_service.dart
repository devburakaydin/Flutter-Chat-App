import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService implements DbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Kullanici kullanici) async {
    await _firestore.collection("users").doc(kullanici.userID).set(kullanici.toMap());
    DocumentSnapshot documentSnapshot = await _firestore.collection("users").doc(kullanici.userID).get();
    Kullanici _kullanici = Kullanici.fromMap(documentSnapshot.data());
    print(_kullanici.toString());

    return true;
  }

  @override
  Future<Kullanici> readUser(String userID) async {
    DocumentSnapshot _okunanUser = await _firestore.collection("users").doc(userID).get();
    Kullanici _okunanUserNesnesi = Kullanici.fromMap(_okunanUser.data());
    print("Okunan user nesnesi :" + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }
}
