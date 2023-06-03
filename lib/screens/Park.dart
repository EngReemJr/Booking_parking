import 'dart:async';
import 'dart:ffi';
import 'package:chat_part/auth/providers/auth_ptoviders.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:grad_project/pages/home_page.dart';
import 'dart:math';
//import '../common/theme_helper.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

class Park extends StatefulWidget {
  const Park({Key? key}) : super(key: key);
  @override
  State<Park> createState() => ParkState();
}

int _currentIndex = 0;

String closestPharmcy = "";
Position? current;
double _closeLatitude = 0.0;
double _closeLongitude = 0.0;
List<String> Lab = [
  "Faisal Street Parking #1 ",
  "Palestine Street Parking #1 ",
  "Nablus Parking",
  "Rafidia Parking",
  "Asira Parking #2",
  "Sufyan Street Parking #1"
];

List<List> Status = [
  ['Free', 'Busy'],
  ['Free', 'Busy'],
  ['Free', 'Busy'],
  ['Free', 'Busy'],
  ['Free', 'Busy'],
  ['Free', 'Busy'],
];
List<String> Beg_time = [
  "8:00",
  "10:00",
  "9:00",
  "8:00",
  "10:00",
  "9:00",
];
List<String> End_time = ["23:00", "22:00", "23:00", "21:00", "22:00", "23:00"];
List<double> lat = [32.22462, 32.22169, 32.21744, 32.22395, 32.25161, 32.22101];
List<double> lang = [
  35.25646,
  35.26105,
  35.27088,
  35.24047,
  35.26650,
  35.24415
];
List<double> dist = [];
TextEditingController txt = TextEditingController();

class ParkState extends State<Park> {
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(32.22300, 35.26263),
    zoom: 15,
  );
  final List<Marker> _markers = <Marker>[];
  @override
  void initState() {
    getloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < Provider.of<AuthProvider>(context,listen: false).AllParkings!.length; i++) {
      _markers.add((Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(Provider.of<AuthProvider>(context,listen: false).AllParkings![i]['lat'], Provider.of<AuthProvider>(context,listen: false).AllParkings![i]['lang']),
        infoWindow: InfoWindow(
          title: Provider.of<AuthProvider>(context,listen: false).AllParkings![i]['name'],
          onTap: () {
            showAlertDialog(context, i);
          },
        ),
      )));
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 159, 198, 223),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Container(
            margin: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.search,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          onPressed: () {
            showAlertDialog(context, int.parse(txt.text) );
            // Navigator.pushReplacement(
            //context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
        backgroundColor: Colors.blue,
        title: Container(
          child: TextFormField(
            controller : txt,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search),
              hintText: "Enter Zone Number",
            ),
          ),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(_markers),
            //  polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      /*floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(10, 370, 280, 0),
        child: Container(
          // decoration: ThemeHelper().buttonBoxDecoration(context),
          child: /*ElevatedButton(
            //style: ThemeHelper().buttonStyle(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Icon(Icons.location_on),
            ),
            onPressed: () async {
              print(dist);
              int ind = dist.indexOf(dist.reduce((min)));
              _closeLatitude = lat[ind];
              _closeLongitude = lang[ind];
              print(closestPharmcy);
              print(ind);
              CameraPosition cameraPosition = new CameraPosition(
                target: LatLng(_closeLatitude, _closeLongitude),
                zoom: 15,
              );
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            },
          ),*/
        ),
      ),*/
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
        /*  onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },*/
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
        ],
        //currentIndex: 0,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/Activity');
              break;
          /*case 1:
              Navigator.pushNamed(context, '/Settings');
              break;*/
            case 2:
              Navigator.pushNamed(context, '/MyOrderScreen');
              break;
            case 3:
              Navigator.pushNamed(context, '/Settings');
              break;
          }
        },
      ),
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future getloc() async {
    await getUserCurrentLocation().then((value) async {
      current = value;
      print(current!.latitude.toString() + " " + current!.longitude.toString());
      _markers.add(Marker(
        markerId: MarkerId("10"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: ' Current Location',
        ),
      ));
      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      dist = [];
      setState(() {
        for (int i = 0; i < lat.length; i++) {
          double distance1 = calculateDistance(
              lat[i], lang[i], current!.latitude, current!.longitude);
          dist.add(distance1);
        }
      });
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  showAlertDialog(BuildContext context, int k) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height * 0.43,
              child: Padding(
                padding:
                EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xff132137),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    /*TextButton(
                        onPressed: () {
                          print("hadiiii");
                        },
                        child: Text(
                          Lab[k],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 9, 78, 153),
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        )),*/
                    Text(
                      Provider.of<AuthProvider>(context,listen: false).AllParkings![k]['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 78, 153),
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      Provider.of<AuthProvider>(context,listen: false).AllParkings![k]['beg_Hour'] + "-" +  Provider.of<AuthProvider>(context,listen: false).AllParkings![k]['end_Hour'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFB475F).withOpacity(.65),
                        fontSize: MediaQuery.of(context).size.height * 0.023,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Text(
                      "Status:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 78, 153),
                        fontSize: MediaQuery.of(context).size.height * 0.024,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    for (int m = 0; m < Status[k].length; m++)
                      text_wed(context, Status[k][m], m),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

double ttop = 0;
Widget text_wed(BuildContext context, String s, int i) {
  if (i != 0) ttop = ttop + 0;
  if (i == 0) ttop = 10;
  return Padding(
    padding: EdgeInsets.only(left: 10, top: ttop),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Activity');
          //print("nassarrrrrrrr");
        },
        child: Text(
          s,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
