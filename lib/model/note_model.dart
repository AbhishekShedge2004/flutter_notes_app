import 'package:database_new/db/db_helper.dart';

class NoteModel{
  int? id;//auto increment
  int? user_id;
  String title;
  String desc;
  String created_at;

  NoteModel({
    this.user_id,
    this.id,
    required this.title,
    required this.desc,
    required this.created_at
  });

  /// methods
  ///1 fromMap to Model
  factory NoteModel.fromMap(Map<String,dynamic> map){
    return NoteModel(
        user_id: map[DBHelper.COLUMN_USER_ID],
        id: map[DBHelper.COLUMN_NOTE_ID],
        title: map[DBHelper.COLUMN_NOTE_TITLE],
        desc: map[DBHelper.COLUMN_NOTE_DESC],
        created_at: map[DBHelper.COLUMN_NOTE_CREATED_AT]
    );
  }



  ///2 from Model toMap
  Map<String,dynamic> toMap(){
    return {
      DBHelper.COLUMN_USER_ID : user_id,
      DBHelper.COLUMN_NOTE_TITLE : title,
      DBHelper.COLUMN_NOTE_DESC : desc,
      DBHelper.COLUMN_NOTE_CREATED_AT : created_at
    };
  }


}









