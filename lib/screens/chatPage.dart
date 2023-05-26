import 'dart:async';

import 'package:badges/badges.dart' as badges;

import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:chat_part/reposetories/authHelper.dart';
import 'package:chat_part/reposetories/firestoreHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';
import '../allConstants/firestore_constants.dart';
import '../allConstants/size_constants.dart';
import '../main.dart';
import '../models/chatUser.dart';

import '../widgets/conversationList.dart';
import 'chatDetailPage.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();
  String _textSearch = "";
//final FirebaseMessaging  _firebaseMessaging = FirebaseMessaging.;
  late String currentUserId;

  final ScrollController scrollController = ScrollController();

  int _limit = 20;

  List<QueryDocumentSnapshot> listMessages = [];





  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
        listMessages[index - 1].get(FirestoreConstants.idFrom) !=
            AuthHelper.authHelper.checkUser()) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
    bool isMessageReceived(int index) {
      if ((index > 0 &&
          listMessages[index - 1].get(FirestoreConstants.idFrom) ==
              AuthHelper.authHelper.checkUser()) ||  index == 0) {
        return true;
      } else {
        return false;
      }
    }

  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
              //  channel.description,
                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
        Provider.of<AuthProvider>(context,listen: false).fill_notification_list(notification.title!);

      }
    });
git
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        showDialog(
           context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            }, );
        Provider.of<AuthProvider>(context,listen: false).fill_notification_list(notification.title!);

      }
    });

    getToken();
  }


  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance!.getToken())!;
    print('My token  :  '+token.toString());
  }

    @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(builder: (context, provider, x) {
     return Scaffold(
        body:

       Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(onPressed: () {
                       provider.signOut();
                      }, child: Icon(Icons.logout)),
                      const Text("Conversations", style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),),
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),

                          child: badges.Badge(
                              badgeAnimation: badges.BadgeAnimation.scale(),
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.circle,
                                badgeGradient: badges.BadgeGradient.linear(
                                  colors: [
                                    Colors.pink,
                                    Colors.red,
                                  ],
                                ),
                              ),
                              badgeContent: Text(
                                  '20',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),

                              child: GestureDetector(child: Icon(Icons.notifications)),
                           ),

                      ),


                      ],
                  ),
                ),
              ),

                    Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.search,
                          controller: provider.searchTextEditingController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              buttonClearController.add(true);
                              setState(() {
                                _textSearch = value;
                              });
                            } else {
                              buttonClearController.add(false);
                              setState(() {
                                _textSearch = "";
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            prefixIcon: Icon(
                              Icons.search, color: Colors.grey.shade600, size: 20,),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100
                                )
                            ),
                          ),
                        ),
                      ),


                      ] ),
                  ),


                SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirestoreHelper.firestoreHelper.getFirestoreData(
                        FirestoreConstants.pathUserCollection,
                        _limit,
                        _textSearch),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0 && provider.loggedUser!.isAdmin) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) =>

                                buildItem(
                                context, snapshot.data?.docs[index])
                            ,
                            controller: scrollController,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                            const Divider(),
                          );
                        }
                        else if((snapshot.data?.docs.length ?? 0) > 0 && !(provider.loggedUser!.isAdmin)){

                          return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder:

                            (context, index) =>

                            (ChatUser.fromDocument(snapshot.data!.docs[index])).isAdmin?
                         buildItem(
                         context, snapshot.data?.docs[index]
                        )
                                 :
                              SizedBox()



                      ,
                      controller: scrollController,
                      separatorBuilder:
                      (BuildContext context, int index) =>
                      const Divider(),
                      );
                        }
                        else {
                          return const Center(
                            child: Text('No user found...'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
            //  ),
            ],
          //),
        ),
      );
  });
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == AuthHelper.authHelper.checkUser()) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                      peerId: userChat.id!,
                      peerAvatar: userChat.imageUrl,
                      peerNickname: userChat.displayName!,
                     userAvatar: userChat.imageUrl,
                    )));
          },
          child: ListTile(
            leading:
           // userChat.photoUrl.isNotEmpty
              //  ?
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.dimen_30),
              child: Image.network(
               userChat.imageUrl!,

                fit: BoxFit.cover,
                width: 50,
                height: 50,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                          color: Colors.grey,
                          value: loadingProgress.expectedTotalBytes !=
                              null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null),
                    );
                  }

                },
                errorBuilder: (context, object, stackTrace) {
                  return const Icon(Icons.account_circle, size: 50);
                },
              ),
            ),
               // : const Icon(
              //Icons.account_circle,
             // size: 50,
            //),
            title: Text(
              userChat.displayName,
              style: const TextStyle(color: Colors.black),
            ),
            trailing:
            const badges.Badge(
              badgeAnimation: badges.BadgeAnimation.scale(),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeGradient: badges.BadgeGradient.linear(
                  colors: [
                    Colors.pink,
                    Colors.red,
                  ],
                ),
              ),
              badgeContent: Text(
                '1',
                style: TextStyle(
                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),

            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}


