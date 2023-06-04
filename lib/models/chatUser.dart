import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../allConstants/firestore_constants.dart';

class ChatUser  {
   String? id;
  String? imageUrl;
  final String displayName;
  final String email;
  final bool isAdmin;
  String? password;

  ChatUser({
     this.id,
    required this.email,
    required this.imageUrl,
    required this.displayName,
    required this.isAdmin,
    this.password
  });

  Map<String, dynamic> toMap() {
    return {

      'email': email,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'isAdmin' : false

    };

  }
  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
      'fullName': displayName,
      'password': password,
      'avatar': imageUrl,
      'isAdmin' : false,
      'email' : email
    };

  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
        email: map['email'] ?? '',
        displayName: map['displayName'] ?? '',
        imageUrl: map['imageUrl']??'https://static.vecteezy.com/system/resources/previews/001/503/756/non_2x/boy-face-avatar-cartoon-free-vector.jpg',
        isAdmin: map['isAdmin'] ?? false);
  }

  factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
    String photoUrl = "";
    String nickname = "";
   // String phoneNumber = "";
    String email = "";
    bool isAdmin = false;

    try {
      photoUrl = snapshot.get(FirestoreConstants.imageUrl);
      nickname = snapshot.get(FirestoreConstants.displayName);
     // phoneNumber = snapshot.get(FirestoreConstants.phoneNumber);
      email = snapshot.get(FirestoreConstants.email);
      isAdmin = snapshot.get(FirestoreConstants.isAdmin);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return ChatUser(
        id: snapshot.id,
        imageUrl: photoUrl,
        displayName: nickname,

        email: email,
        isAdmin: isAdmin
    );
  }

  //String toJson() => json.encode(toMap());

  factory  ChatUser.fromJson(Map<String, dynamic> json) {
     return ChatUser(
       id: json['_id']  ,
         email: json['email'] ?? '',
         displayName: json['fullName'] ?? '',
         imageUrl: json['avatar']??'https://static.vecteezy.com/system/resources/previews/001/503/756/non_2x/boy-face-avatar-cartoon-free-vector.jpg',
         isAdmin: json['isAdmin'] ?? false);
  }


}


