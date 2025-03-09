import 'package:database_new/db/db_helper.dart';

abstract class dbBlocEvents{}

class addData extends dbBlocEvents{
  String newTitle;
  String newDesc;
  String createdAt;
  addData({required this.newTitle, required this.newDesc, required this.createdAt});
}

class getInitialData extends dbBlocEvents{}

class deleteData extends dbBlocEvents{
  int id;
  deleteData({required this.id});
}

class updateData extends dbBlocEvents{
  String updatedTitle;
  String updatedDesc;
  String updatedAt;
  int id;
  updateData({required this.updatedTitle, required this.updatedDesc, required this.updatedAt, required this.id});
}