

import 'dart:convert';

import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'authHelper.dart';
import 'package:http/http.dart' as http;

class NotificationHelper{
  NotificationHelper._();

  static NotificationHelper notificationHelper = NotificationHelper._();


  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance!.getToken())!;
    print('My token  :  '+token.toString());
    saveToken(token);
  }
  void saveToken(String token) async{
    await FirebaseFirestore.instance.collection('UserTokens').doc(AuthHelper.authHelper.checkUser()).set({
      'token' : token,

    });
  }
  Future<String> getTokenFromFireStore(String id) async{
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('UserTokens').doc(id).get();
    String token =snap['token'];

return token;
  }
   void sendPushMessage(String token , String body , String title , String id) async{
    try{
      await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String , String>{
            'Content-Type' : 'application/json',
            'Authorization' : 'key=AAAAqGYBZ90:APA91bGocA7jDHWA1RfLF5G38mWSzDki_GQ0Du4urUZW07GeVsiN0ruPqZ3aq3noGUPP9FvkN7DwAhiVibMfNKkcdYC1Zh1iJZ4ag21uMD0gK_Is9FpSytRvUQVVV9850Hd_Ycq8cy2g'
          },
          body: jsonEncode(
              <String , dynamic>{
                'notification' :<String , dynamic>{
                  'body' : '$body%$id',
                  'title' : '$title'
                },
                'priority' : 'high',
                'data' :<String , dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id' : '1',
                  'status' : 'done'
                },
                'to' : '$token'
              }
          )
      );

    }
    catch(e){
      print(e.toString());
    }
  }


}

