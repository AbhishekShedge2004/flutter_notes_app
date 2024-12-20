import "package:database_new/db_helper.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../note_model.dart";
import "db_state.dart";

class DBCubit extends Cubit<DBState>{
  
  DBHelper dbHelper;

  DBCubit({required this.dbHelper}) : super(DBInitialState());

  ///events
  void addData({required String mTitle, required String mDesc, required String mCreatedAt}) async {
    emit(DBLoadingState());

    Future.delayed(Duration(seconds: 2), () async {
      bool check = await dbHelper.addNote(
          NoteModel(title: mTitle, desc: mDesc, created_at: mCreatedAt)
      );
      if (check) {
        var allNotes = await dbHelper.getAllNotesFromDB();
        emit(DBLoadedState(mData: allNotes));
      } else {
        emit(DBErrorState(errorMsg: "Note not added"));
      }
    },);
  }

  void getInitialNotes() async {
    emit(DBLoadingState());

    Future.delayed(Duration(seconds: 2), () async{
      var allNotes = await dbHelper.getAllNotesFromDB();
      emit(DBLoadedState(mData: allNotes));
    },);
  }

  void updateData({required String mUpdatedTitle, required String mUpdatedDesc, required String mUpdatedAt, required int id}) async{
    emit(DBLoadingState());

    Future.delayed(Duration(seconds: 2), () async{
      bool check = await dbHelper.updateNote(
          updatedTitle: mUpdatedTitle,
          updatedDesc: mUpdatedDesc,
          updatedAt: mUpdatedAt,
          id: id
      );
      if(check){
        var allNotes = await dbHelper.getAllNotesFromDB();
        emit(DBLoadedState(mData: allNotes));
      }else{
        emit(DBErrorState(errorMsg: "Note not added"));
      }
    },);
  }

  void deleteData({required int id}) async{
    emit(DBLoadingState());

    Future.delayed(Duration(seconds: 2), () async{
      bool check = await dbHelper.deleteNote(
          id: id
      );
      if(check){
        var allData = await dbHelper.getAllNotesFromDB();
        emit(DBLoadedState(mData: allData));
      }else{
        emit(DBErrorState(errorMsg: "Note not added"));
      }
    },);
  }


}
