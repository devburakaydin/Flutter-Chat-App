import 'package:cloud_firestore/cloud_firestore.dart';

class Sohbet {
  final String konusmaSahibi;
  final String kimleKonusuyor;
  final bool goruldu;
  final Timestamp olusturulmaTarihi;
  final String sonYollananMesaj;
  final Timestamp gorulmeTarihi;
  String name;
  String konusulanUserName;
  String konusulanUserProfilURL;
  DateTime sonOkunmaZamani;
  String aradakiFark;

  Sohbet({this.konusmaSahibi, this.kimleKonusuyor, this.goruldu, this.olusturulmaTarihi, this.sonYollananMesaj, this.gorulmeTarihi});

  Map<String, dynamic> toMap() {
    return {
      'konusmaSahibi': konusmaSahibi,
      'kimleKonusuyor': kimleKonusuyor,
      'goruldu': goruldu,
      'olusturulmaTarihi': olusturulmaTarihi ?? FieldValue.serverTimestamp(),
      'sonYollananMesaj': sonYollananMesaj ?? FieldValue.serverTimestamp(),
      'gorulmeTarihi': gorulmeTarihi,
    };
  }

  Sohbet.fromMap(Map<String, dynamic> map)
      : konusmaSahibi = map['konusmaSahibi'],
        kimleKonusuyor = map['kimleKonusuyor'],
        goruldu = map['goruldu'],
        olusturulmaTarihi = map['olusturulmaTarihi'],
        sonYollananMesaj = map['sonYollananMesaj'],
        gorulmeTarihi = map['gorulmeTarihi'];

  @override
  String toString() {
    return 'Sohbet{konusmaSahibi: $konusmaSahibi, kimleKonusuyor: $kimleKonusuyor, goruldu: $goruldu, olusturulmaTarihi: $olusturulmaTarihi, sonYollananMesaj: $sonYollananMesaj, gorulmeTarihi: $gorulmeTarihi, konusulanUserName: $konusulanUserName, konusulanUserProfilURL: $konusulanUserProfilURL, sonOkunmaZamani: $sonOkunmaZamani, aradakiFark: $aradakiFark}';
  }
}
