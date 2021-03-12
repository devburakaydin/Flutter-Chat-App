import 'package:chat_app/locator.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<Kullanici> _tumKullanicilar;
  Kullanici _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 5;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();

  List<Kullanici> get kullanicilarListesi => _tumKullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  getUserWithPagination(Kullanici enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar.last;
    }

    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUserWithSayfalama(_enSonGetirilenUser, sayfaBasinaGonderiSayisi);
    if (yeniListe.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }
    _tumKullanicilar.addAll(yeniListe);

    state = AllUserViewState.Loaded;
    /*





    _tumKullanicilar.addAll(yeniListe);

    state = AllUserViewState.Loaded;
     */
  }

  Future<void> dahaFazlaKullaniciGetir() async {
    if (_hasMore) getUserWithPagination(_enSonGetirilenUser, true);
    await Future.delayed(Duration(seconds: 2));
  }

/*


  Future<void> dahaFazlaUserGetir() async {
    // print("Daha fazla user getir tetiklendi - viewmodeldeyiz -");

    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }
   */

  Future<void> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    await getUserWithPagination(_enSonGetirilenUser, true);
  }
}
