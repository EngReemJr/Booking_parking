import 'dart:async';
//import 'package:firstapp/Park.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:grad_project/pages/home_page.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../auth/providers/auth_ptoviders.dart';
//import '../common/theme_helper.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  int _currentIndex = 2;
  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(builder: (context, provider, index) {
      return
       Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(onPressed:(){
            Navigator.pushNamed(context,'/ChatPage' );
          }, icon: Icon(Icons.chat)),
          IconButton(onPressed:(){
           provider.signOut();
          }, icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(children: [
                 /* provider.DbloggedUser == null?
                      Center(
                        child: CircularProgressIndicator(),

                      ):*/

                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1))
                        ],
                        shape: BoxShape.circle,

                        image: DecorationImage(image: NetworkImage(

                           provider.getLoginImage()
                          )

                        )),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ))
                ]),
              ),
              SizedBox(
                height: 30,
              ),
              Container(child: buildTextField("Full Name",
                  provider.getLoginName()
                  , false)),
              buildTextField("Email",
                  provider.getLoginEmail(),

                  false),
              //buildTextField("password", "********", true),
              buildTextField("Location", "Nablus", false),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        // fixedColor:Colors.black ,
        selectedFontSize: 25,
        unselectedFontSize: 20,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        iconSize: 30,
        /* onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },*/
        items: [
        /*  BottomNavigationBarItem(
           icon: Icon(Icons.av_timer),
            label: "Activity",
            backgroundColor: Colors.black,
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: "Park",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Reserve",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            backgroundColor: Colors.black,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:

              Navigator.pushNamed(context, '/Park');


              break;
            case 1:
              Navigator.pushNamed(context, '/MyOrderScreen');

              break;
            case 2:

              Navigator.pushNamed(context, '/Settings');

              break;
             /* case 3:

              Navigator.pushNamed(context, '/Settings');
              setState(() {
                _currentIndex = index;
              });
              break;*/
          }
        },
      ),
    );});
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ))
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
      ),
    );
  }
}
