//import 'package:firstapp/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_ptoviders.dart';


//import 'package:slider_button/slider_button.dart';
//import '../widgets/round-button.dart';
//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with TickerProviderStateMixin {
  late AuthProvider myProvider;
  int _currentIndex = 0;
  //static const moonIcon = CupertionIcons.moon_stars;
  static const moonIcon = CupertinoIcons.moon_stars;


  @override
  void initState() {
    super.initState();


    AuthProvider.controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5, /*hours: 4, minutes: 5*/
      ),
    );
    myProvider = new AuthProvider();
   // AuthProvider.authProvider.IntilizeController();

  }

  @override
  void dispose() {
    AuthProvider.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, x) {

      return Scaffold(
      appBar: AppBar(
        title: Text('Activtty'),
        actions: [
          IconButton(
            icon: const Icon(
              moonIcon,
              color: Colors.grey,
            ),
            onPressed: () {
            // ThemeService().changeTheme();
            },
          )
        ],
      ),
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 390),
                  child: Text(
                    provider.getLoginName(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(),
                Container(
                    margin: EdgeInsets.only(bottom: 200),
                    child: Text(
                      "Parking time",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    )),
                // Icon(Icons.money),
                /*   Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 145, top: 440),
                        child: Icon(Icons.money)),
                    Container(
                        margin: EdgeInsets.only(top: 440),
                        child: Text(
                          " 10 ₪ /h ",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),*/
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    //backgroundColor: Colors.red,
                    value: provider.progress,
                    strokeWidth: 6,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if ( AuthProvider.controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: AuthProvider.controller.duration!,
                            onTimerDurationChanged: (time) {
                              AuthProvider.controller.duration = time;
                              setState(() {

                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: AuthProvider.controller,
                    builder: (context, child) => Text(
                      provider.countText,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/second');

                  },
                  child: RoundButton(

                    icon: provider.isPlaying == true ? Icons.pause :
                    Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AuthProvider.controller.reset();

                      provider.isPlaying = false;

                  },
                  child: RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          )
          
        ],
      ),
      /*
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
            label: "Activity",
            backgroundColor: Colors.black,
          ),
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
            /*case 0:
              Navigator.pushNamed(context, '/Activity');
              break;*/
            case 1:
              Navigator.pushNamed(context, '/Park');
              //_currentIndex = index;
              break;
            case 2:
              Navigator.pushNamed(context, '/MyOrderScreen');
              break;
            case 3:
              Navigator.pushNamed(context, '/Settings');
              break;
          }
        },
      ),*/
    );
    });
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        child: Icon(
          icon,
          size: 36,
        ),
      ),
    );
  }
}



/*
import 'dart:async';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);
  @override
  State<Activity> createState() => ActivityState();
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        child: Icon(
          icon,
          size: 36,
        ),
      ),
    );
  }
}

class ActivityState extends State<Activity> with TickerProviderStateMixin {
  late AnimationController controller;
  int _currentIndex = 0;
  String get countText {
    Duration count = controller.duration! * controller.value;
    return '${count.inSeconds % 60}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Text(
                countText,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.reverse(
                        from: controller.value == 0 ? 1.0 : controller.value);
                  },
                  child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_arrow),
                      label: Text("")),
                ),
                TextButton.icon(
                    onPressed: () {}, icon: Icon(Icons.stop), label: Text(""))
              ],
            ),
          )
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.av_timer),
              label: "Activity",
              backgroundColor: Colors.black,
            ),
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
          ]),
    );
  }
}*/
