import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  Kullanici _kullanici;

  Kullanici get kullanici => _kullanici;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  Future<Kullanici> currentUser() async {
    try {
      state = ViewState.Busy;
      _kullanici = await _userRepository.currentUser();
      return _kullanici;
    } catch (e) {
      debugPrint("hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      if (sonuc == true) {
        _kullanici = null;
      }

      return sonuc;
    } catch (e) {
      debugPrint("hata : " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<Kullanici> singInAnonymously() async {
    try {
      state = ViewState.Busy;
      _kullanici = await _userRepository.singInAnonymously();
      return _kullanici;
    } catch (e) {
      debugPrint("hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<Kullanici> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _kullanici = await _userRepository.signInWithGoogle();
      return _kullanici;
    } catch (e) {
      debugPrint("hata signInWithGoogle : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
}
