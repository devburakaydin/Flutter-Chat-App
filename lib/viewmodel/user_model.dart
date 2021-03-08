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
      bool sonuc = await _userRepository.signOut();
      _kullanici = null;

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

  Future<bool> userNameUpdate(String userName, String userID) async {
    bool sonuc = await _userRepository.userNameUpdate(userName, userID);
    if (sonuc) {
      currentUser();
      return true;
    }
    return false;
  }

  Future<List<Kullanici>> getAllUser() async {
    var tumKullanicilar = await _userRepository.getAllUser();
    return tumKullanicilar;
  }

  Future<Kullanici> signInWithGoogle() async {
    _kullanici = await _userRepository.signInWithGoogle();
    if (_kullanici != null) {
      state = ViewState.Idle;
    }
    return _kullanici;
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
    return await _userRepository.uploadFile(userID, fileType, yuklenecekDosya);
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID) {
    return _userRepository.getMessages(currentUserID, konusulanUserID);
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj);
  }

  Future<List<Sohbet>> getAllSohbetler(String userID) async {
    return await _userRepository.getAllSohbetler(userID);
  }
}
