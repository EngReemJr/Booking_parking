import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../allConstants/firestore_constants.dart';

class ChatUser extends Equatable {
    String? id;
   String? imageUrl;
  final String displayName;


  final String email;
  final bool isAdmin;
   ChatUser(
      { this.id,
        required this.email,
        required this.imageUrl,
        required this.displayName,

        required this.isAdmin
      });
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'imageUrl': imageUrl
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
        email: map['email'] ?? '',
        displayName: map['displayName'] ?? '',
        imageUrl: map['imageUrl'],
        isAdmin: map['isAdmin'] ?? false);
  }
    factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
      String photoUrl = "";
      String nickname = "";
      String phoneNumber = "";
      String email = "";
      bool isAdmin = false ;

      try {
        photoUrl = snapshot.get(FirestoreConstants.imageUrl);
        nickname = snapshot.get(FirestoreConstants.displayName);
        phoneNumber = snapshot.get(FirestoreConstants.phoneNumber);
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
  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source));

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


