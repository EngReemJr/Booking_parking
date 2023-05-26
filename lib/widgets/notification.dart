import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class notification_list extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
   return Container(
     child: ListView.builder(
         itemCount: Provider.of<AuthProvider>(context).notification_list.length,
         itemBuilder: (BuildContext context, int index) {
           return ListTile(
               leading: const Icon(Icons.notifications_active),
               trailing:  Text(
                 Provider.of<AuthProvider>(context ).notification_list[index].toString(),
                 style: TextStyle(color: Colors.green, fontSize: 15),
               ),
               title: Text("List item $index"));
         }),
   );


  }



}