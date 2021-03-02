import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();

  Future<Kullanici> currentUser() async {
    Kullanici _kullanici = await _firebaseAuthService.currentUser();
    return await _firebaseDbService.readUser(_kullanici.userID);
  }

  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<Kullanici> singInAnonymously() async {
    return await _firebaseAuthService.singInAnonymously();
  }

  Future<Kullanici> signInWithGoogle() async {
    Kullanici _kullanici = await _firebaseAuthService.signInWithGoogle();
    bool sonuc = await _firebaseDbService.saveUser(_kullanici);
    if (sonuc == true) {
      return await _firebaseDbService.readUser(_kullanici.userID);
    } else {
      return null;
    }
  }

  Future<Kullanici> signInWithEmailAndPassword(String email, String sifre) async {
    Kullanici _kullanici = await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);
    bool sonuc = await _firebaseDbService.saveUser(_kullanici);
    if (sonuc == true) {
      return await _firebaseDbService.readUser(_kullanici.userID);
    } else {
      return null;
    }
  }

  Future<Kullanici> createUserWithEmailAndPassword(String email, String sifre) async {
    Kullanici _kullanici = await _firebaseAuthService.createUserWithEmailAndPassword(email, sifre);
    bool sonuc = await _firebaseDbService.saveUser(_kullanici);
    if (sonuc == true) {
      return await _firebaseDbService.readUser(_kullanici.userID);
    } else {
      return null;
    }
  }
}
