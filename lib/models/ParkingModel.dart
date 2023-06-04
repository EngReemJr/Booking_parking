import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../allConstants/firestore_constants.dart';

class Parking  {
  String? id;
  final String name;
  final String beg_Hour;
  final String end_Hour;
  final double lat;
  final double lang;

  Parking({ this.id,
    required this.name,
    required this.beg_Hour,
    required this.end_Hour,
    required this.lat,
    required this.lang,

  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'beg_Hour': beg_Hour,
      'end_Hour' : end_Hour,
      'lat' : lat
      ,
      'lang' : lang

    };

  }


  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
        name: map['name'] ?? '',
        beg_Hour: map['beg_Hour'] ?? '',
        end_Hour: map['end_Hour']??'',
        lat: map['lat']??''
        ,
        lang: map['lang']??''

    );
  }

  factory Parking.fromDocument(DocumentSnapshot snapshot) {
    String name = "";
    String beg_Hour = "";

    String end_Hour = "";

   late double lat ;
    late double lang ;
    try {
      name = snapshot.get('name');
      beg_Hour = snapshot.get('beg_Hour');
      end_Hour = snapshot.get('end_Hour');
      lat = snapshot.get('lat');
      lang = snapshot.get('lang');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return Parking(
        id: snapshot.id,
        name: name,
        beg_Hour: beg_Hour,
        end_Hour: end_Hour,
      lat: lat,
      lang: lang,

    );
  }


}


