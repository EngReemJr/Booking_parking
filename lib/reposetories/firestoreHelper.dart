import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_part/allConstants/all_constants.dart';
import 'package:chat_part/models/chatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/message.dart';


class FirestoreHelper {
  FirestoreHelper._();

  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
List tokens = [];

  //register
  addNewUser(ChatUser appUser) async {
    firestore.collection('Users').doc(appUser.id).set(appUser.toMap());
  }

  //login
  Future<ChatUser> getUserFromFirestore(String id) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await firestore.collection('Users').doc(id).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    ChatUser appUser = ChatUser.fromMap(data!);
    return appUser;
  }

  updateTheUser(ChatUser chatuser) async {
    await firestore.collection('Users').doc(chatuser.id).update(chatuser.toMap());
  }
  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }



  Stream<QuerySnapshot> getFirestoreData(

      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true ) {
      return firestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreConstants.displayName,isEqualTo: textSearch!)
          .snapshots()

      ;

    } else {
      return firestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }

  }
  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }


/*  //// admin methods
  Future<String?> addNewCategory(Category category) async {
    try {
      DocumentReference<Map<String, dynamic>> categoryDocument =
      await firestore.collection('categories').add(category.toMap());

      return categoryDocument.id;
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<bool> deleteCategoey(String catId) async {
    try {
      await firestore.collection('categories').doc(catId).delete();
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
*/

  /*
  SaveMessageNot(String Id, int value)  {

    prefs.setInt(Id, value);
  }
  int getMessageNot(String Id , String type)  {
   // Fluttertoast.showToast(msg: Id.toString() + ' id');
    int intValue = prefs.getInt(Id)??0;
    if(type == 'i'){
      intValue = intValue +1;
    }

    return intValue;
  }*/
  Future<List<ChatUser>?> getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
      await firestore.collection('Users').get();
      List<ChatUser> users = userSnapshot.docs.map((doc) {
        ChatUser cUser = ChatUser.fromMap(doc.data());
        cUser.id = doc.id;
        return cUser;
      }).toList();
      return users;
    } on Exception catch (e) {
      log(e.toString());
    }
  }
  Future<List<String>?> getAllTokens() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
      await firestore.collection('UserTokens').get();

      List<String> tokens = userSnapshot.docs.map((doc) {

        String uToken = doc.data()['token'];
        return uToken;
      }).toList();
      return tokens;
    } on Exception catch (e) {
      log(e.toString());
    }
  }
/*
  Future<bool?> updateCategory(Category category) async {
    try {
      await firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }*/
}