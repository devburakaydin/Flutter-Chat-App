import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Kullanici {
  final String userID;
  String email;
  String userName;
  String name;
  String durum;
  String profilURL;
  DateTime createdAt;
  DateTime updatedAt;

  @override
  String toString() {
    return 'Kullanici{userID: $userID, email: $email, userName: $userName, name: $name, durum: $durum, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  Kullanici({@required this.userID, this.email, this.userName, this.name, this.durum, this.profilURL, this.createdAt, this.updatedAt});

  Kullanici.idveResim({@required this.userID, this.profilURL, this.name, this.userName});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'name': name,
      'durum': durum ?? 'Müsait',
      'userName': userName,
      'profilURL': profilURL ??
          'https://firebasestorage.googleapis.com/v0/b/limonchat-991f0.appspot.com/o/yellow-user-icon.png?alt=media&token=d114cd7e-a21a-49cb-8ecc-841b0171da2b',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  Kullanici.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        name = map['name'],
        durum = map['durum'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        userName = map['userName'];
}
