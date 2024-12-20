import 'package:database_new/db_helper.dart';
import 'package:database_new/note_model.dart';
import 'package:flutter/material.dart';

class DBProvider extends ChangeNotifier{
  DBHelper dbHelper;
  DBProvider({required this.dbHelper});

  //data
  List<NoteModel> _mData = [];

  //insert
  void addNote({required String mTitle, required String mDesc, required String mCreatedAt}) async{
    bool check = await dbHelper.addNote(
       NoteModel(title: mTitle, desc: mDesc, created_at: mCreatedAt)
    );
    if(check){
      _mData = await dbHelper.getAllNotesFromDB();
      notifyListeners();
    }
  }

  List<NoteModel> getAllNotesFromProvider(){
    return _mData;
  }

  //fetch initial notes
  void getInitialNotes() async{
    _mData = await dbHelper.getAllNotesFromDB();
    notifyListeners();
  }

  //update
  void updateNote({required String mUpdateTitle, required String mUpdateDesc, required String mUpdateAt, required int id}) async{
    bool check = await dbHelper.updateNote(
        updatedTitle: mUpdateTitle,
        updatedDesc: mUpdateDesc,
        updatedAt: mUpdateAt,
        id: id
    );
    if(check){
      _mData = await dbHelper.getAllNotesFromDB();
      notifyListeners();
    }

  }

  //delete
  void deleteNote({required int id}) async{
    bool check = await dbHelper.deleteNote(id: id);
    if(check){
      _mData = await dbHelper.getAllNotesFromDB();
      notifyListeners();
    }

  }





}