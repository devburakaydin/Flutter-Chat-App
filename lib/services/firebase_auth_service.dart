import 'package:chat_app/models/kullanici.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Kullanici> currentUser() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      return Kullanici(userID: user.uid);
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    await _firebaseAuth.signOut();

    await GoogleSignIn().signOut();
    return true;
  }

  Future<Kullanici> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential sonuc = await _firebaseAuth.signInWithCredential(credential);
    print(sonuc.user.email);

    if (sonuc != null) {
      return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email);
    } else {
      return null;
    }
  }

  Future<Kullanici> signInWithEmailAndPassword(String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
    if (sonuc != null) {
      return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email);
    } else {
      return null;
    }
  }

  Future<Kullanici> createUserWithEmailAndPassword(String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
    if (sonuc != null) {
      return Kullanici(userID: sonuc.user.uid, email: sonuc.user.email);
    } else {
      return null;
    }
  }
}
