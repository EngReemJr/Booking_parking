//introductionScreen

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Rplespage extends StatefulWidget {
  const Rplespage({Key? key}) : super(key: key);

  @override
  State<Rplespage> createState() => _RplespageState();
}

class _RplespageState extends State<Rplespage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          body: IntroductionScreen(
              pages: [
                PageViewModel(
                  title: 'Welcome ',
                  body: '',
                  image: buildImage("asset/images/02.jpg"),
                  //getPageDecoration, a method to customise the page style
                  decoration: getPageDecoration(),
                ),
                PageViewModel(
                  title: 'Book your appointment from the comfort of your home',
                  body: '',
                  image: buildImage("asset/images/04.png"),
                  //getPageDecoration, a method to customise the page style
                  decoration: getPageDecoration(),
                ),
                PageViewModel(
                  title: 'Shop from your home and get fast delivery',
                  body: '',
                  image: buildImage("asset/images/06.jpg"),
                  //getPageDecoration, a method to customise the page style
                  decoration: getPageDecoration(),
                ),
                PageViewModel(
                  title: 'please select if you are :',
                  // body: '',
                  image: buildImage("asset/images/08.jpg"),
                  // bodyWidget:  TextButton(
                  //   child: Text('user'),
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => AuthScreen(role: "user")));
                  //   }, ),
                  bodyWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 25, color: Colors.pink),
                        ),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AuthScreen(role: "user")));
                        },
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        '',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      TextButton(
                        child: Text('',
                            style: TextStyle(fontSize: 20, color: Colors.pink)),
                        onPressed: () {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) =>
                          //           ));
                        },
                      ),
                    ],
                  ),
                  //getPageDecoration, a method to customise the page style
                  decoration: getPageDecoration(),
                ),
              ],
              onDone: () {
                if (kDebugMode) {
                  Navigator.pushNamed(context, '/Login');
                }
              },
              //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
              scrollPhysics: const ClampingScrollPhysics(),
              showDoneButton: true,
              showNextButton: true,
              showSkipButton: true,
              isBottomSafeArea: true,
              skip:
              const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),
              next: const Icon(Icons.forward),
              done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
              dotsDecorator: getDotsDecorator()),
        ));
    //);
  }

  Widget buildImage(String imagePath) {
    return Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ));
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 0, right: 0, bottom: 0),
      imageFlex: 5,
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 0, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 0),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(color: Colors.black, fontSize: 30),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.indigo,
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
