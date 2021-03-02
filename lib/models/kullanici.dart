import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Kullanici {
  final String userID;
  String email;
  String userName;
  DateTime createdAt;
  DateTime updatedAt;

  @override
  String toString() {
    return 'Kullanici{userID: $userID, email: $email, userName: $userName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  Kullanici({@required this.userID, this.email, this.userName, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  Kullanici.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        userName = map['userName'];
}
