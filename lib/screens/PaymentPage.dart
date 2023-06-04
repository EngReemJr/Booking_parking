import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

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
                Container(
                    margin: EdgeInsets.only(right: 180),
                    child: Text(
                      "Parking Name",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
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
                    onPressed: () {
                      if (AuthProvider.controller.isAnimating) {
                        AuthProvider.controller.stop();
                          provider.changePlayingValue(false);
                      } else {
                        AuthProvider.controller.reverse(
                            from: AuthProvider.controller.value == 0 ? 1.0 :
                            AuthProvider.controller.value);
                        provider.changePlayingValue(true);
                      provider.BookParking(
                        cardNumber,
                        cvvNumber,
                        cardHolderName

                      );
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
