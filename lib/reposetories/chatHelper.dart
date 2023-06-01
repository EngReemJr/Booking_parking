
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../allConstants/firestore_constants.dart';
import '../auth/providers/auth_ptoviders.dart';
import '../screens/loginScreen.dart';
import 'authHelper.dart';
import 'firestoreHelper.dart';

class ChatHelper {
  ChatHelper._();

  static ChatHelper chatHelper = ChatHelper._();

  final TextEditingController textEditingController = TextEditingController();
  String groupChatId = '';
  File? imageFile;
  bool isLoading = false;
  String imageUrl = '';
  int limit = 20;
  final int limitIncrement = 20;
  late String currentUserId;
  bool isShowSticker = false;


  List<QueryDocumentSnapshot> listMessages = [];
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();


  void onSendMessage(String content, int type , String peerId) {
    if (content.trim().isNotEmpty) {
      ChatHelper.chatHelper.textEditingController.clear();
      FirestoreHelper.firestoreHelper.sendChatMessage(
          content, type, groupChatId, AuthHelper.authHelper.checkUser()!, peerId);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);


    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }
  void readLocal( String peerId , BuildContext context) {
    if (AuthHelper.authHelper.checkUser()?.isNotEmpty == true) {
      currentUserId = AuthHelper.authHelper.checkUser()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  loginScreen()),
              (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId - ${peerId}';
    } else {
      groupChatId = '${peerId} - $currentUserId';
    }
    FirestoreHelper.firestoreHelper.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: peerId});
  }
  // checking if sent message
  bool isMessageSent(int index , BuildContext context) {
    if ((index > 0 &&
        listMessages[index - 1].get(FirestoreConstants.idFrom) !=
            Provider.of<AuthProvider>(context,listen: false).loggedUser) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
  bool isMessageReceived(int index , BuildContext context) {
    if ((index > 0 &&
     listMessages[index - 1].get(FirestoreConstants.idFrom) ==
            Provider.of<AuthProvider>(context,listen: false).loggedUser) ||  index == 0) {
      return true;
    } else {
      return false;
    }
  }


}