
import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'Activity.dart';

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  String cardNumber = '';
  String cardHolderName = '';
  String cvvNumber = '';
  String expiryDate = '';
  bool showBackView = false;
  String parkingName = Activity.ParkingName;

 void onCreditCardModel(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      cardHolderName = creditCardModel.cardHolderName;
      expiryDate = creditCardModel.expiryDate;
      cvvNumber = creditCardModel.cvvCode;
      showBackView = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, x) {

      return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Credit Card Ui'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 180),
                      child: Text(
                          parkingName
                       ,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                Icon(Icons.money),
                Container(
                    // margin: EdgeInsets.only(right: 280),
                    child: Text(
                  " 10 ₪ /h ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              height: 210,
              cardHolderName: cardHolderName,
              cvvCode: cvvNumber,
              showBackView: showBackView,
              cardBgColor: Colors.greenAccent,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              animationDuration: Duration(milliseconds: 1200),
              onCreditCardWidgetChange: (CreditCardBrand) {

              },
            ),
            Expanded(
              child: SingleChildScrollView(
        child:
            CreditCardForm(
                  onCreditCardModelChange: onCreditCardModel,
                  cursorColor: Colors.red,
                  themeColor: Colors.black,
                  cardHolderName: '',
                  cardNumber: '',
                  expiryDate: '',
                  cvvCode: '',
                  formKey: GlobalKey(),
                ),
              ),
            ),
            Container(
                //margin: EdgeInsets.only(top: 200),
                child: TextButton(
                    onPressed: () async{
                      if (AuthProvider.controller.isAnimating) {
                        AuthProvider.controller.stop();
                          provider.changePlayingValue(false);
                      } else {
                        AuthProvider.controller.reverse(
                            from: AuthProvider.controller.value == 0 ? 1.0 :
                            AuthProvider.controller.value);
                        provider.changePlayingValue(true);
                        var temp = DateTime.now().toUtc();
                        var d1 = DateTime.utc(temp.year,temp.month);
                        var d2 = DateTime.utc(int.parse('20'+expiryDate.split('/')[1]),int.parse(expiryDate.split('/')[0]));
                          if(d1.compareTo(d2)==-1){
                      await provider.BookParking(
                        cardNumber,
                        cvvNumber,
                        cardHolderName

                      );
                        Navigator.pop(context);

                          }
                          else{
                            Fluttertoast.showToast(msg: 'Invalid card');
                          }
                      }
                      
                    },
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
  );}
}
