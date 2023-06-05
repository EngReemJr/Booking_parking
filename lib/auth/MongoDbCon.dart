import 'dart:developer';

import 'package:chat_part/allConstants/dbConstants.dart';
import 'package:chat_part/models/chatUser.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/Booking.dart';
import '../models/Payment.dart';

class MongoDbCon {
  MongoDbCon._();
  static MongoDbCon mongoDbCon = MongoDbCon._();

static var db ;
late var userCollection, parkingCollection,paymentCollection,bookingCollection;
 connect() async{
  try {
    db = await Db.create(MONGO_CON_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    parkingCollection = db.collection(PARKING_COLLECTION);
    paymentCollection = db.collection(PAYMENT_COLLECTION);
    bookingCollection = db.collection(BOOKING_COLLECTION);
  }catch(e){
    print(e );
  }
}


 Future<String> insertUser(ChatUser cUser)async{
  try {

   var result =
    await userCollection.insertOne(cUser.toJson());

  //  print('${result.isSuccess}');
    if(result.isSuccess){
return 'Success inserted';
    }
   else{
      return  'Failed inserted';

  }
   }
  catch(e){
print(e.toString());
return e.toString();
  }
}
  Future<String> insertPayment(Payment payment)async{
    try {

      var result =
      await paymentCollection.insertOne(payment.toMap());

      //print('${result.isSuccess}');
      if(result.isSuccess){
        return 'Pay Done';
      }
      else{
        return  'Pay Failed';

      }
    }
    catch(e){
      print(e.toString());
      return e.toString();
    }
  }
  Future<String> insertBooking(Booking book)async{
    try {

      var result =
      await bookingCollection.insertOne(book.toMap());

      //print('${result.isSuccess}');
      if(result.isSuccess){
        return 'Booking Success';
      }
      else{
        return  'Booking Failed';

      }
    }
    catch(e){
     // print(e.toString());
      return e.toString();
    }
  }
/*
Future<Map<String,dynamic>> getDataUser(String email , String password)async{


    List<Map<String,dynamic>> arrData = await userCollection.find().toList();
  Map<String,dynamic> DbloggedUser ={};
   arrData.map((e) => e['email'] == email && e['password']==password?
      DbloggedUser = e

   //print(e['fullName'])
       :

   );

   return DbloggedUser;
}
*/



}