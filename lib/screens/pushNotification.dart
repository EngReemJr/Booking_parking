import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:chat_part/reposetories/notificationHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class PushNotofication extends StatefulWidget {
  const PushNotofication({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PushNotoficationState createState() => _PushNotoficationState();
}

class _PushNotoficationState extends State<PushNotofication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SignUpForm()),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String _title = '';

  String _body = '';



  @override
  Widget build(BuildContext context) {

    return
      Form(
          key: _formKey,
          child: ListView(
            children: getFormWidget(),
          ))
    ;
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];
formWidget.add(
  Padding(
  padding:
  EdgeInsets.only( top: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 8, right: 8, top: 2, bottom: 2),
          height: 30,
      
          child: Icon(Icons.arrow_back),
        ),
      ),
      const Text("Notify User", style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold),),

    ],
  ),
),);
formWidget.add(SizedBox(height: MediaQuery.of(context).size.height*0.15,));
    formWidget.add(TextFormField(
      decoration:
      const InputDecoration(labelText: 'Enter notification title', hintText: 'Title'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a title';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _title = value.toString();
        });
      },
    ));

    validateEmail(String? value) {
      if (value!.isEmpty) {
        return 'Please enter mail';
      }

      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value.toString())) {
        return 'Enter Valid Email';
      } else {
        return null;
      }
    }



    formWidget.add(TextFormField(
      decoration:
      const InputDecoration(hintText: 'body', labelText: 'Enter body'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter notification body';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _body = value!;
        });
      },
    ));

formWidget.add(SizedBox(height: MediaQuery.of(context).size.height*0.50,));

    void onPressedSubmit() {
      if (_formKey.currentState!.validate() ) {
        _formKey.currentState?.save();

        Provider.of<AuthProvider>(context,listen: false).tokens?.forEach((element) {
          if(NotificationHelper.notificationHelper.token!=element) {
            NotificationHelper.notificationHelper.sendPushMessage(
                element, _body, _title, '');
          }
        });


        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Notification Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Push Notification'), onPressed: (){
      onPressedSubmit();




    }));

    return formWidget;
  }
}
