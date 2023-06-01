import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import '../../app_router/app_router.dart';
import '../../models/chatUser.dart';
import '../../reposetories/firestoreHelper.dart';
import '../../reposetories/storage_helper.dart';
import '../../screens/HomePage.dart';
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
  TextEditingController passwordLoginController = TextEditingController();
  late String email;
  late String password;
  ChatUser? loggedUser;
  static late  AnimationController controller ;
  bool isPlaying = false;
  int notification_counter = 0;
  double progress = 1.0;
  List  notification_list = [];

  late SharedPreferences prefs  ;
List <String >?tokens = [];
  AuthProvider()  {
  intialSharedPref();
  getTokens();
}

intialSharedPref()async{
  prefs = await SharedPreferences.getInstance();

}

  IntilizeController(){
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        progress = controller.value;
      } else {
        progress = 1.0;
        isPlaying = false;
      }
    });



  }

  SaveMessageNot(String Id, int value)  {


    prefs.setInt(Id, value);
    notifyListeners();
  }
  int getMessageNot(String Id )  {

    int intValue = prefs.getInt(Id)??0;

    return intValue;
  }

  changePlayingValue(bool newValue) {
    isPlaying = newValue;
    notifyListeners();
  }
  fill_notification_list(String newNotify){
    notification_list.add(newNotify);

    notification_counter++;
    notifyListeners();

  }
  /*fill_user_list(String idUser , int counterMsg){
    messageNotification[idUser] = counterMsg;
    print(messageNotification[idUser]);
        notifyListeners();


  }*/

  setNotificationCounter(){
    notification_counter=0;
    notifyListeners();
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
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
        AppRouter.appRouter.goToWidgetAndReplace(HomePage());
      }
    }
  }

  SignUp() async {
    if (signUpKey.currentState!.validate()) {
      AppRouter.appRouter.showLoadingDialoug();
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
        // AppRouter.appRouter.goToWidgetAndReplace(MainScreen());
        // AppRouter.appRouter.hideDialoug();

      }
    }
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
      AppRouter.appRouter.goToWidgetAndReplace(HomePage());
    } else {
      AppRouter.appRouter.goToWidgetAndReplace(loginScreen());
    }
  }


  signOut() async {
    await AuthHelper.authHelper.signOut();
    AppRouter.appRouter.goToWidgetAndReplace(loginScreen());
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