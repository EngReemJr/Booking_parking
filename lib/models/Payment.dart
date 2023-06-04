import 'package:chat_part/models/ParkingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
class Payment  {
  String? id;
  final String user_id;
  final String booking_id;
  final num amount ;
  final String card_num;
  final String CVV;
  final String card_holder;

  Payment({
    this.id,
    required this.user_id,
    required this.booking_id,
    required this.amount,
    required this.card_num,
    required this.CVV,
    required this.card_holder,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': user_id,
      'booking_id': booking_id,
      'amount' : amount,
      'card_num' : card_num,
      'CVV' : CVV,
      'card_holder' : card_holder,

    };

  }


  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
        user_id: map['user_id'] ?? '',
        booking_id: map['booking_id'] ?? '',
        amount: map['amount']??0,
        card_num: map['card_num']??'',
        CVV: map['CVV']??'',
        card_holder: map[' card_holder']??''

    );
  }

  factory Payment.fromDocument(DocumentSnapshot snapshot) {
    String user_id = "";
    String booking_id = "";

    num amount = 0;

    String card_num ='';
    String CVV ='';
    String card_holder ='';
    try {
      user_id = snapshot.get('user_id');
      booking_id = snapshot.get('booking_id');
      amount = snapshot.get('amount');
      card_num = snapshot.get('card_num');
      CVV = snapshot.get('CVV');
      card_holder = snapshot.get('card_holder');

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return Payment(
      id: snapshot.id,
      user_id: user_id,
      booking_id: booking_id,
      amount: amount,
      card_num: card_num,
      CVV: CVV,
      card_holder: card_holder,

    );
  }


}


