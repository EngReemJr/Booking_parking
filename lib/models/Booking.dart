import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
class Booking  {
  dynamic? id;
  final String user_id;
  final String parking_id;
  final Duration duration;
  final String status;

  Booking({
    this.id,
    required this.user_id,
    required this.parking_id,
    required this.duration,
    required this.status,

  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': user_id,
      'parking_id': parking_id,
      'duration' : duration.inHours,
      'status' : status

    };

  }


  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
        user_id: map['user_id'] ?? '',
        parking_id: map['parking_id'] ?? '',
        duration: map['duration']??'00:00',
        status: map['status']??''


    );
  }

  factory Booking.fromDocument(DocumentSnapshot snapshot) {
    String user_id = "";
    String parking_id = "";

    Duration duration = Duration(hours: 0, minutes: 0, seconds: 0);

     String status ='';
    try {
      user_id = snapshot.get('user_id');
      parking_id = snapshot.get('parking_id');
      duration = snapshot.get('duration');
      status = snapshot.get('status');

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return Booking(
      id: snapshot.id,
      user_id: user_id,
      parking_id: parking_id,
      duration: duration,
      status: status,

    );
  }


}


