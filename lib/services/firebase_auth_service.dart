import 'package:chat_app/models/kullanici.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Kullanici> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      if (user != null) {
        return Kullanici(userID: user.uid);
      } else {
        return null;
      }
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  Future<Kullanici> singInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email, userName: sonuc.user.displayName);
    } catch (e) {
      print("anonim giris hata:" + e.toString());
      return null;
    }
  }

  Future<Kullanici> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential sonuc = await _firebaseAuth.signInWithCredential(credential);
      if (sonuc != null) {
        return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email, userName: sonuc.user.displayName);
      } else {
        return null;
      }
    } catch (e) {
      print("google giris hata:" + e.toString());
      return null;
    }
  }

  Future<Kullanici> signInWithEmailAndPassword(String email, String sifre) async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
      if (sonuc != null) {
        return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email, userName: sonuc.user.displayName);
      } else {
        return null;
      }
    } catch (e) {
      print("email giriş hata :" + e.toString());
      return null;
    }
  }

  Future<Kullanici> createUserWithEmailAndPassword(String email, String sifre) async {
    try {
      UserCredential sonuc =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
      if (sonuc != null) {
        return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email, userName: sonuc.user.displayName);
      } else {
        return null;
      }
    } catch (e) {
      print("email user oluşturma hata :" + e.toString());
      return null;
    }
  }
}
