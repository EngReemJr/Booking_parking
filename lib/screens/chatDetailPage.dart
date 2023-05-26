import 'dart:developer';
import 'dart:io';

import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:chat_part/models/message.dart';
import 'package:chat_part/reposetories/authHelper.dart';
import 'package:chat_part/reposetories/chatHelper.dart';
import 'package:chat_part/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../allConstants/color_constants.dart';
import '../allConstants/firestore_constants.dart';
import '../allConstants/size_constants.dart';
import '../component/chatImage.dart';
import '../reposetories/firestoreHelper.dart';
import '../reposetories/storage_helper.dart';

class ChatDetailPage extends StatefulWidget{

  final String peerId;
  final String? peerAvatar;
  final String peerNickname;
   String? userAvatar;

   ChatDetailPage(
      {Key? key,
        required this.peerNickname,
        required this.peerAvatar,
        required this.peerId,
         this.userAvatar})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {


  void initState() {
    super.initState();

    ChatHelper.chatHelper.focusNode.addListener(onFocusChanged);
    ChatHelper.chatHelper.scrollController.addListener(_scrollListener);
    ChatHelper.chatHelper.readLocal( widget.peerId,context);
  }
  _scrollListener() {
    if (ChatHelper.chatHelper.scrollController.offset >= ChatHelper.chatHelper.scrollController.position.maxScrollExtent &&
        !ChatHelper.chatHelper.scrollController.position.outOfRange) {
      setState(() {
        ChatHelper.chatHelper.limit += ChatHelper.chatHelper.limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (ChatHelper.chatHelper.focusNode.hasFocus) {
      setState(() {
        ChatHelper.chatHelper.isShowSticker = false;
      });
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = StorageHelper.storageHelper.uploadImageFile(ChatHelper.chatHelper.imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      ChatHelper.chatHelper.imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        ChatHelper.chatHelper.isLoading = false;
        ChatHelper.chatHelper.onSendMessage(ChatHelper.chatHelper.imageUrl, MessageType.image , widget.peerId);
      });
    } on FirebaseException catch (e) {
      setState(() {
        ChatHelper.chatHelper.isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }
  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ChatHelper.chatHelper.imageFile = File(pickedFile.path);
      if (ChatHelper.chatHelper.imageFile != null) {
        setState(() {
          ChatHelper.chatHelper.isLoading = true;
        });
        uploadImageFile();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userAvatar!),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.peerNickname,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                  Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
    children: <Widget>[
    Column(

      children: [Flexible(
      child: ChatHelper.chatHelper.groupChatId.isNotEmpty
      ? StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper.firestoreHelper.getChatMessage(ChatHelper.chatHelper.groupChatId, ChatHelper.chatHelper.limit),
      builder: (BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          ChatHelper.chatHelper.listMessages = snapshot.data!.docs;
          if (ChatHelper.chatHelper.listMessages.isNotEmpty) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data?.docs.length,
                reverse: true,
                controller: ChatHelper.chatHelper.scrollController,
                itemBuilder: (context, index) =>
                    buildItem(index, snapshot.data?.docs[index]))

            ;

          } else {
            return const Center(
              child: Text('No messages...'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.burgundy,
            ),
          );
        }
          })
            : const Center(
        child: CircularProgressIndicator(
        color: AppColors.burgundy,
        ),
        ),
        ),
    ])
          ,


    Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[

            SizedBox(width: 15,),
            Expanded(
              child: TextField(
                focusNode: ChatHelper.chatHelper.focusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller:ChatHelper.chatHelper.textEditingController ,
                decoration: const InputDecoration(

                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
                onSubmitted: (value) {
                  ChatHelper.chatHelper.onSendMessage( ChatHelper.chatHelper.textEditingController.text,MessageType.text , widget.peerId);
                },
              ),
            ),
            SizedBox(width: 15,),
            Container(
              margin: const EdgeInsets.only(right: Sizes.dimen_4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(Sizes.dimen_30),
              ),
              child: IconButton(
                onPressed: getImage,
                icon: const Icon(
                  Icons.camera_alt,
                  size: Sizes.dimen_28,
                ),
                color: AppColors.white,
              ),
            ),
            FloatingActionButton(
              onPressed: (){
                ChatHelper.chatHelper.onSendMessage(ChatHelper.chatHelper.textEditingController.text, MessageType.text , widget.peerId);
              },
              child: Icon(Icons.send,color: Colors.white,size: 18,),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],

        ),
      ),
    ),
  ])    );

  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == ChatHelper.chatHelper.currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ?
                 Container(
                  margin: const EdgeInsets.only(right: Sizes.dimen_10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(chatMessages.content, style: TextStyle(fontSize: 15),),
                )

                    : chatMessages.type == MessageType.image
                    ? Container(
                  margin: const EdgeInsets.only(
                      right: Sizes.dimen_10, top: Sizes.dimen_10),
                  child: chatImage(
                      imageSrc: chatMessages.content, onTap: () {}),
                )
                    : const SizedBox.shrink(),
                ChatHelper.chatHelper.isMessageSent(index , context)
                    ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.dimen_20),
                  ),
                  child: Image.network(
                   Provider.of<AuthProvider>(context).loggedUser!.imageUrl!,

                    width: Sizes.dimen_40,
                    height: Sizes.dimen_40,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.burgundy,
                          value: loadingProgress.expectedTotalBytes !=
                              null &&
                              loadingProgress.expectedTotalBytes !=
                                  null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 35,
                        color: AppColors.greyColor,
                      );
                    },
                  ),
                )
                    : Container(
                  width: 35,
                ),
              ],
            ),
            ChatHelper.chatHelper.isMessageSent(index , context)
                ? Container(
              margin: const EdgeInsets.only(
                  right: Sizes.dimen_50,
                  top: Sizes.dimen_6,
                  bottom: Sizes.dimen_8),
              child: Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: Sizes.dimen_12,
                    fontStyle: FontStyle.italic),
              ),
            )



                : const SizedBox.shrink(),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChatHelper.chatHelper.isMessageReceived(index,context)
                // left side (received message)
                    ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.dimen_20),
                  ),
                  child: Image.network(
                    widget.userAvatar!,

                    width: Sizes.dimen_40,
                    height: Sizes.dimen_40,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.burgundy,
                          value: loadingProgress.expectedTotalBytes !=
                              null &&
                              loadingProgress.expectedTotalBytes !=
                                  null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 35,
                        color: AppColors.greyColor,
                      );
                    },
                  ),
                )
                    : Container(
                  width: 35,
                ),
                chatMessages.type == MessageType.text
                    ?
                Container(
                  margin: const EdgeInsets.only(left: Sizes.dimen_10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.greyColor,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(chatMessages.content, style: TextStyle(fontSize: 15),),
                )

                    : chatMessages.type == MessageType.image
                    ? Container(
                  margin: const EdgeInsets.only(
                      left: Sizes.dimen_10, top: Sizes.dimen_10),
                  child: chatImage(
                      imageSrc: chatMessages.content, onTap: () {}),
                )
                    : const SizedBox.shrink(),


              ],
            ),
            ChatHelper.chatHelper.isMessageReceived(index,context)
                ? Container(
              margin: const EdgeInsets.only(
                  left: Sizes.dimen_50,
                  top: Sizes.dimen_6,
                  bottom: Sizes.dimen_8),
              child: Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(chatMessages.timestamp),
                  ),
                ),
                style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: Sizes.dimen_12,
                    fontStyle: FontStyle.italic),
              ),
            )
                : const SizedBox.shrink()
    ,
    SizedBox(height: MediaQuery.of(context).size.height*0.05,)
          ],

        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: ChatHelper.chatHelper.groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
          stream: FirestoreHelper.firestoreHelper.getChatMessage(ChatHelper.chatHelper.groupChatId, ChatHelper.chatHelper.limit),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              ChatHelper.chatHelper.listMessages = snapshot.data!.docs;
              if (ChatHelper.chatHelper.listMessages.isNotEmpty) {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    controller: ChatHelper.chatHelper.scrollController,
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data?.docs[index]));
              } else {
                return const Center(
                  child: Text('No messages...'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.burgundy,
                ),
              );
            }
          })
          : const Center(
        child: CircularProgressIndicator(
          color: AppColors.burgundy,
        ),
      ),
    );
  }

}