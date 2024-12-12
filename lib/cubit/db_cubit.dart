import "package:database_new/db_helper.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "db_state.dart";

class DBCubit extends Cubit<DBState>{
  
  DBHelper dbHelper;

  DBCubit({required this.dbHelper}) : super(DBInitialState());

  ///events
  void addData({required String mTitle, required String mDesc, required String mCreatedAt}) async {
    emit(DBLoadingState());

    Future.delayed(Duration(seconds: 4), () async {
      bool check = await dbHelper.addNote(
          title: mTitle,
          desc: mDesc,
          createdAt: mCreatedAt
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

    var allNotes = await dbHelper.getAllNotesFromDB();
    emit(DBLoadedState(mData: allNotes));
  }
}
