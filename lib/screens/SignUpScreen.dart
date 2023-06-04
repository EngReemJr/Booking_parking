import 'package:chat_part/app_router/app_router.dart';
import 'package:chat_part/reposetories/DbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_ptoviders.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String adminUser = ""; //no radio button will be selected
  //String gender = "male"; //if you want to set default value
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, x) {

      return


      Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body:  Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Color(0x665ac18e),
              ])),
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: provider.signUpKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 30),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  margin: EdgeInsets.only(top: 60),
                  child: TextFormField(
                    controller: provider.userNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    validator: (v)=> provider.emailValidation(v!)
,
                    keyboardType: TextInputType.emailAddress
                    ,
                    controller: provider.registerEmailController,
                    decoration: InputDecoration(

                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    validator: (v) => provider.passwordValidation(v!),
                    controller: provider.passwordRegisterController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    validator: (v) => provider.passwordConfirm(v!),
                    controller: provider.ConpasswordRegisterController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    children: [
                    //  Padding(padding: EdgeInsets.symmetric(horizontal: 18)),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xff4c505b),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    /*  Expanded(
                        child: RadioListTile(
                          title: Text(
                            "Admin",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          value: "Admin",
                          groupValue: adminUser,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            provider.changeUserAdmin(true);
                            setState(() {
                              adminUser = value.toString();
                            });
                          },
                        ),
                      ),*/
                    /*  Container(
                        width: 300,
                        child: Expanded(
                          child: RadioListTile(
                            title: Text(
                              "User",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            activeColor: Colors.green,
                            value: "User",
                            groupValue: adminUser,
                            onChanged: (value) {
                              provider.changeUserAdmin(false);
                              setState(() {
                                adminUser = value.toString();
                              });
                            },
                          ),
                        ),
                      ),*/

//******

                         Container(
                          width: 130,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {



      provider.SignUp();



                                },
                                icon: Icon(Icons.arrow_forward)),
                          ),
                        ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

    );});
  }
}
