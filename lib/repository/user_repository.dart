import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();

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
}
