import 'package:chat_part/models/chatUser.dart';
import 'package:chat_part/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_router/app_router.dart';
import '../auth/providers/auth_ptoviders.dart';
import 'package:provider/provider.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool isRememberMe = false;
  Widget buildEmail() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextFormField(
              validator:  (v) =>
                Provider.of<AuthProvider>(context,listen: false).emailValidation(v!)
              ,
              controller: Provider.of<AuthProvider>(context).loginEmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xff5ac18e),
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.black38,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget buildpassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator:  (v) =>
                Provider.of<AuthProvider>(context,listen: false).passwordValidation(v!)
            ,
            controller: Provider.of<AuthProvider>(context).passwordLoginController,
            obscureText: true,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff5ac18e),
                ),
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }
  Widget buildForgotPassBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => print("Forgot Password Pressed"),
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget buildRemmeberCb() {
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value!;
                });
              },
            ),
          ),
          Text(
            "Remember me",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5,
        onPressed: ()async {
         await Provider.of<AuthProvider>(context,listen: false).DbsignIn();
          if(Provider.of<AuthProvider>(context,listen: false).DbloginUser!=null && Provider.of<AuthProvider>(context,listen: false).DbloginUser!.isNotEmpty){
          List<ChatUser>  cUser =  Provider.of<AuthProvider>(context,listen: false).DbloginUser!.map((e){
              return ChatUser.fromJson(e);
            }).toList();
          Provider.of<AuthProvider>(context,listen: false).DbcheckUser(cUser);
          Provider.of<AuthProvider>(context,listen: false).signIn();
            Provider.of<AuthProvider>(context,listen: false).loginEmailController.clear();
            Provider.of<AuthProvider>(context,listen: false).passwordLoginController.clear();

          }else{
            Fluttertoast.showToast(msg: 'Error Login');
          }

        },


        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Text(
          "LOGIN",
          style: TextStyle(
              color: Color(0xff5ac18e),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return GestureDetector(
      onTap: () => AppRouter.appRouter.goToWidgetAndReplace(SignUpScreen()),
      child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "Don\'t have an Account?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            TextSpan(
                text: "Sign Up",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return

      Container(
      child:

          Consumer<AuthProvider>(builder: (context, provider, x) {
            return
      Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue,
                            Color(0x665ac18e),
                          ])),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 120),
                    child: Form(
                      key: provider.signInKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          buildEmail(),
                          SizedBox(
                            height: 20,
                          ),
                          buildpassword(),
                          SizedBox(
                            height: 10,
                          ),
                          buildForgotPassBtn(),
                          buildRemmeberCb(),
                          buildLoginBtn(),
                          buildSignUpBtn(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }) );
  }
}