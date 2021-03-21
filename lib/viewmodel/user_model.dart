import 'dart:io';

import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/models/sohbet.dart';
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
      print("current user bulunamadı boş : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      _kullanici = null;
      bool sonuc = await _userRepository.signOut();

      return sonuc;
    } catch (e) {
      debugPrint("signOut Hatası : " + e.toString());

      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> emailSearch(String email) async {
    return await _userRepository.emailSearch(email);
  }

  Future<bool> userNameSearch(String userName) async {
    return await _userRepository.userNameSearch(userName);
  }

  Future<bool> userUpdate(String veribaslik, String userID, String veri) async {
    bool sonuc = await _userRepository.userUpdate(veribaslik, userID, veri);
    if (sonuc) {
      if (veribaslik == "userName")
        _kullanici.userName = veri;
      else if (veribaslik == "name")
        _kullanici.name = veri;
      else if (veribaslik == "durum") _kullanici.durum = veri;
      notifyListeners();
    }
    return sonuc;
  }

  Future<bool> userNameUpdate(String userName, String userID) async {
    bool sonuc = await _userRepository.userNameUpdate(userName, userID);
    if (sonuc) {
      currentUser();
      return true;
    }
    return false;
  }

  Future<Kullanici> signInWithGoogle() async {
    try {
      state = ViewState.Busy;

      _kullanici = await _userRepository.signInWithGoogle();
      return _kullanici;
    } catch (e) {
      print("hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<Kullanici> signInWithEmailAndPassword(String email, String sifre) async {
    _kullanici = await _userRepository.signInWithEmailAndPassword(email, sifre);
    if (_kullanici != null) {
      state = ViewState.Idle;
    }
    return _kullanici;
  }

  Future<Kullanici> createUserWithEmailAndPassword(String email, String sifre) async {
    _kullanici = await _userRepository.createUserWithEmailAndPassword(email, sifre);
    if (_kullanici != null) {
      state = ViewState.Idle;
    }
    return _kullanici;
  }

  Future<String> uploadFile(String userID, String fileType, File yuklenecekDosya) async {
    String url = await _userRepository.uploadFile(userID, fileType, yuklenecekDosya);
    if (url != null) {
      _kullanici.profilURL = url;
    }

    return url;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID) {
    return _userRepository.getMessages(currentUserID, konusulanUserID);
  }

  Future<List<Sohbet>> getAllSohbetler(String userID) async {
    return await _userRepository.getAllSohbetler(userID);
  }

  Future<List<Kullanici>> getUserWithSayfalama(Kullanici enSonGelenUser, int getirilecekUserSayisi) async {
    return await _userRepository.getUserWithSayfalama(enSonGelenUser, getirilecekUserSayisi);
  }
}
