import 'package:chat_app/models/kullanici.dart';
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
}
