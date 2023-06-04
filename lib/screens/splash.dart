

import 'package:chat_part/app_router/app_router.dart';
import 'package:chat_part/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_ptoviders.dart';
import '../models/chatUser.dart';

class SplachScreen extends StatelessWidget {
  navigationFun(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
        Provider.of<AuthProvider>(context, listen: false).checkUser();

  }

  @override
  Widget build(BuildContext context) {
    navigationFun(context);
    // TODO: implement build
    return
      Scaffold(

          body:   Container(

              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 195, 14),
              )
          ,
            child: Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.25,
                  height: MediaQuery.of(context).size.height*0.25,
                  child: Image(image: AssetImage('asset/images/play_store_512.png'),)),
            ),
          ));
  }
}