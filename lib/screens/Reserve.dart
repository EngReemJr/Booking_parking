import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_ptoviders.dart';

class MyOrderScreen extends StatelessWidget {
  int _currentIndex = 1;
  static const routeName = "/myOrderScreen";

  @override
  Widget build(BuildContext context) {
return  Consumer<AuthProvider>(builder: (context, provider, x) {

  return Scaffold(
      appBar: AppBar(
        title: Text('My Parking History'),
      ),
      body:

      Stack(
        children: [
          SafeArea(
            child: Column(
              children: [


                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      child: Text(
                        "User Name :",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: Text(
                        provider.getLoginName(),
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                              ],
                            ),
                            Row(
                              children: [],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.2,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                     Column(
                     children: [
                        // Text("data"),
                      /*  ProductCard(
                          price: "20",
                          name: "Faisal street parking",
                        ),
                        ProductCard(
                          price: "30",
                          name: "Palestine street parking",
                        ),*/
                       Expanded( child:
                       ListView.builder(
                        // shrinkWrap: true,
                            itemCount: provider.UserBookingPayment!.length!,
                            itemBuilder: (BuildContext context, int index) {
                              print('AMount == ' +provider.UserBookingPayment![index]['amount'].toString());
                              return

                                ProductCard(
                                  price: provider.UserBookingPayment![index]['amount'].toString() ,
                                  name: provider.UserBookingPayment![index]['name'].toString() ,
                                )

                              ;
                            }),
                  )
                     ],
                   ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Date",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "12/4/2022",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      /* Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Sub Total",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "\$68",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),*/
                      SizedBox(
                        height: 10,
                      ),
                      /* Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Delivery Cost",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "\$2",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),*/

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            " ₪ 70",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context)
                            //     .pushNamed(CheckoutScreen.routeName);
                          },
                          child: Text("Done"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   // child: CustomNavBar(),
          // ),
        ],
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
          /*BottomNavigationBarItem(
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
          /*setState(() {
            _currentIndex = index;
          });*/
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/Park');
              break;
            case 1:
              Navigator.pushNamed(context, '/MyOrderScreen');
              //_currentIndex = index;
              break;
              case 2:
              Navigator.pushNamed(context, '/Settings');
              break;
              /*
            case 3:
              Navigator.pushNamed(context, '/Settings');
              break;*/
          }
        },
      ),
    );});
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required String name,
    required String price,
    bool isLast = false,
  })  : _name = name,
        _price = price,
        _isLast = isLast,
        super(key: key);

  final String _name;
  final String _price;
  final bool _isLast;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: _isLast
              ? BorderSide.none
              : BorderSide(
            // color: AppColor.placeholder.withOpacity(0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${_name}  ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "\₪ $_price ",
            style: TextStyle(
              // color: AppColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }
}
