import 'dart:developer';

import 'package:chat_part/auth/MongoDbCon.dart';
import 'package:chat_part/models/BarkingModel.dart';
import 'package:chat_part/models/chatUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../app_router/app_router.dart';

class DbHelper{
  DbHelper._();
   static DbHelper dbHelper = DbHelper._();

   Future<void> insertUser(String displayName , String password , String email ) async{
var _id = mongo.ObjectId();
print('${_id}');
final  cUser = ChatUser(id : '${_id}',email: email, imageUrl: 'https://img.freepik.com/premium-vector/little-kid-avatar-profile_18591-50926.jpg?w=740', displayName: displayName, password: password,isAdmin: false);
 MongoDbCon.mongoDbCon.insertUser(cUser);
//Fluttertoast.showToast(msg: result.toString());

   }
  Future<List<Map<String, dynamic>>?> getUser(String email, String password) async{
try{

    Future<List<Map<String, dynamic>>> LoggedUser = MongoDbCon.mongoDbCon.userCollection.find({ 'email': email , 'password': password }).toList();

    return LoggedUser ;


}
    catch(e){
  print(e.toString());
    }
//Fluttertoast.showToast(msg: result.toString());

  }


  Future<List<Map<String, dynamic>>?> getAllParkings() async {
    try {
      Future<List<Map<String, dynamic>>> ParkDocument = MongoDbCon.mongoDbCon.parkingCollection.find().toList();
      return ParkDocument;
    } on Exception catch (e) {
      log(e.toString());
    }
  }


}