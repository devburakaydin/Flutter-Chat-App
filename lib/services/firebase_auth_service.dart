import 'package:chat_app/models/kullanici.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Kullanici> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      if(user!=null){
        return Kullanici(
            userID: user.uid, email: user.email, userName: user.displayName);
      }else{
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
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  Future<Kullanici> singInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return Kullanici(
          userID: sonuc.user.uid,
          email: sonuc.user.email,
          userName: sonuc.user.displayName);
    } catch (e) {
      print("anonim giris hata:" + e.toString());
      return null;
    }
  }
}
