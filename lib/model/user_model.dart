import 'package:database_new/db/db_helper.dart';

class UserModel{
  int? uId;
  String uName;
  String uEmail;
  String uPass;

  UserModel({
    this.uId,
    required this.uName,
    required this.uEmail,
    required this.uPass
  });

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
        uId: map[DBHelper.COLUMN_USER_ID],
        uName: map[DBHelper.COLUMN_USER_NAME],
        uEmail: map[DBHelper.COLUMN_USER_EMAIL],
        uPass: map[DBHelper.COLUMN_USER_PASS]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      DBHelper.COLUMN_USER_NAME: uName,
      DBHelper.COLUMN_USER_EMAIL: uEmail,
      DBHelper.COLUMN_USER_PASS: uPass
    };
  }

}