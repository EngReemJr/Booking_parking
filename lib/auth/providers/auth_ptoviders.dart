import 'dart:io';
import 'package:chat_part/reposetories/DbHelper.dart';
import 'package:chat_part/screens/Settings.dart';
import 'package:chat_part/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import '../../app_router/app_router.dart';
import '../../models/ParkingModel.dart';
import '../../models/chatUser.dart';
import '../../reposetories/firestoreHelper.dart';
import '../../reposetories/storage_helper.dart';
import '../../screens/HomePage.dart';
import '../../screens/introductionScreen.dart';
import '../../screens/loginScreen.dart';
import '../../reposetories/authHelper.dart';


class AuthProvider extends ChangeNotifier {
  GlobalKey<FormState> signInKey = GlobalKey();
  GlobalKey<FormState> signUpKey = GlobalKey();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController ConpasswordRegisterController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  late String email;
  late int ActiveBookNum;
  late String password;
  ChatUser? loggedUser;
  List<Map<String, dynamic>>? DbloginUser = [];
  List<Map<String, dynamic>>? AllParkings;
  List<Map<String, dynamic>>? AllBooking;
  late ChatUser? DbloggedUser;
  static late AnimationController controller;
String selectedParking = '';
  bool isPlaying = false;
  int notification_counter = 0;
  double progress = 1.0;
  List notification_list = [];

  late SharedPreferences prefs;

  List <String>?tokens = [];

  AuthProvider() {
    intialSharedPref();
    getTokens();
    getAllParkings();
    getAllBookings();
  }

  intialSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  IntilizeController() {
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        progress = controller.value;
      } else {
        progress = 1.0;
        isPlaying = false;

        notifyListeners();
      }
    });
  }
  changeControllerDuration(Duration time){
    controller.duration = time;
    notifyListeners();

  }
  changeSelectedParking(String id){
    selectedParking = id;
    ActiveBooking(id);
    notifyListeners();

  }

  SaveMessageNot(String Id, int value) {
    prefs.setInt(Id, value);
    notifyListeners();
  }
  SaveLoginDetails(ChatUser cu) {
    prefs.setString('Id', cu.id!);
    prefs.setString('name', cu.displayName);
    prefs.setString('email', cu.email);
    prefs.setString('image', cu.imageUrl!);
    notifyListeners();
  }
  ResetLoginDetails() {
    prefs.setString('Id', '');
    prefs.setString('name', '');
    prefs.setString('email', '');
    prefs.setString('image', '');
    notifyListeners();
  }

  String getLoginName() {
    String name = prefs.getString('name') ?? '';

    return name;
  }
  String getLoginEmail() {
    String email = prefs.getString('email') ?? '';

    return email;
  }
  String getLoginId() {
    String Id = prefs.getString('Id') ?? '';

    return Id;
  }
  String getLoginImage() {
    String image = prefs.getString('image') ?? '';

    return image;
  }
  int getMessageNot(String Id) {
    int intValue = prefs.getInt(Id) ?? 0;

    return intValue;
  }

  changePlayingValue(bool newValue) {
    isPlaying = newValue;
    notifyListeners();
  }

  fill_notification_list(String newNotify) {
    notification_list.add(newNotify);

    notification_counter++;
    notifyListeners();
  }


  setNotificationCounter() {
    notification_counter = 0;
    notifyListeners();
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes %
        60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60)
        .toString()
        .padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(
        2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void notify() {
    if (countText == '0:00:00') {
      //FlutterRingtonePlayer.playNotification();
    }
  }

  String? emailValidation(String email) {
    if (email == null || email.isEmpty) {
      return "Required field";
    } else if (!(isEmail(email))) {
      return "Incorrect email syntax";
    }
  }

  String? passwordValidation(String password) {
    if (password == null || password.isEmpty) {
      return "Required field";
    }
    else if (password.length <= 3) {
      return 'Error, the password must be larger than 6 letters';
    }
  }

  String? passwordConfirm(String password) {
    if (password == null || password.isEmpty) {
      return "Required field";
    }
    else if (password != passwordRegisterController.text) {
      return 'Error, the password must be the same';
    }
  }

  String? requiredValidation(String content) {
    if (content == null || content.isEmpty) {
      return "Required field";
    }
  }


  signIn() async {
    if (signInKey.currentState!.validate()) {
      signInKey.currentState!.save();
      String? userId = await AuthHelper.authHelper
          .signIn(loginEmailController.text, passwordLoginController.text);
      if (userId != null) {
        loggedUser =
        await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
        getUser(userId);
        notifyListeners();
        AppRouter.appRouter.goToWidgetAndReplace(Settings());
      }
    }
  }

  DbsignIn() async {
    if (signInKey.currentState!.validate()) {
      signInKey.currentState!.save();
      DbloginUser = await DbHelper.dbHelper.getUser(
          loginEmailController.text, passwordLoginController.text);
    }
    notifyListeners();
  }

  DbcheckUser(List<ChatUser> loginUser) {
    if (loginUser.isNotEmpty) {
      DbloggedUser = loginUser.elementAt(0);
      SaveLoginDetails(DbloggedUser!);

    }
    else {
      DbloggedUser = null;
    }
    notifyListeners();
  }


  SignUp() async {
    if (signUpKey.currentState!.validate()) {
     await DbHelper.dbHelper.insertUser(userNameController.text, passwordRegisterController.text, registerEmailController.text);

      String? result = await AuthHelper.authHelper.signUp(
          registerEmailController.text, passwordRegisterController.text);
      if (result != null) {
        FirestoreHelper.firestoreHelper.addNewUser(ChatUser(
          id: result,
          email: registerEmailController.text,
          isAdmin: false,
          imageUrl: 'https://img.freepik.com/premium-vector/little-kid-avatar-profile_18591-50926.jpg?w=740',
          displayName: userNameController.text,
        ));
        Fluttertoast.showToast(msg: 'Register Completed you can login now');
        AppRouter.appRouter.goToWidgetAndReplace(loginScreen());


      }

    }
  }
  BookParking(String CardNum , String cvv , String cardHolder ) async {

    String bookId  = await DbHelper.dbHelper.insertBook(getLoginId(),selectedParking,controller.duration!);
 Fluttertoast.showToast(msg: bookId);
  paymentDetails(CardNum , cvv , cardHolder , bookId);

  }
  paymentDetails(String CardNum , String cvv , String cardHolder , String bookId ) async {
    await DbHelper.dbHelper.insertPayment(getLoginId(),
      ((int.parse(controller.duration!.inHours.toString()))*10),
      bookId,
      cardHolder,
      CardNum,
      cvv
    );
  }

  getUser(String id) async {
    loggedUser = await FirestoreHelper.firestoreHelper.getUserFromFirestore(id);
    loggedUser!.id = id;
    notifyListeners();
  }

  getTokens() async {
    tokens = (await FirestoreHelper.firestoreHelper.getAllTokens());
    notifyListeners();
  }

  checkUser() async {
    String? userId = AuthHelper.authHelper.checkUser();

    if (userId != null) {
      getUser(userId);
      AppRouter.appRouter.goToWidgetAndReplace(Settings());
    } else {
      AppRouter.appRouter.goToWidgetAndReplace(Rplespage());
    }
  }

  getAllParkings() async {
    AllParkings = await DbHelper.dbHelper.getAllParkings();

    notifyListeners();
  }
  getAllBookings() async {
    AllBooking = await DbHelper.dbHelper.getAllBookings();

    notifyListeners();
  }
  ActiveBooking(String parkingId){
    ActiveBookNum = 0;
AllBooking?.forEach((element) {

  if(element['status']=='active'&&element['parking_id']==parkingId){
    ActiveBookNum = ActiveBookNum+1;
  }
  notifyListeners();

});
  }

  signOut() async {
    try {
      await AppRouter.appRouter.SignOutReplacement();
      await AuthHelper.authHelper.signOut();
       ResetLoginDetails();
      DbcheckUser([]);
      DbloginUser = [];
    }
    catch (e) {

    }
  }

  uploadNewFile() async {
    XFile? pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(pickedFile!.path);
    String imageUrl =
    await StorageHelper.storageHelper.uploadNewImage('user_images', file);

    loggedUser!.imageUrl = imageUrl;
    getUser(loggedUser!.id!);
    await FirestoreHelper.firestoreHelper.updateTheUser(loggedUser!);
  }
}
