import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/services/firebase_auth_service.dart';

class UserRepository {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  Future<Kullanici> currentUser() async {
    return await _firebaseAuthService.currentUser();
  }

  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<Kullanici> singInAnonymously() async {
    return await _firebaseAuthService.singInAnonymously();
  }
}
