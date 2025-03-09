import 'package:database_new/bloc/db_bloc_events.dart';
import 'package:database_new/bloc/db_bloc_state.dart';
import 'package:database_new/db/db_helper.dart';
import 'package:database_new/model/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class dbBloc extends Bloc<dbBlocEvents,dbBlocState>{
  DBHelper dbHelper;

  dbBloc({required this.dbHelper}) : super(InitialState()){

    ///add note
    on<addData>((event, emit) async {
      bool check = await dbHelper.addNote(
          NoteModel( title: event.newTitle, desc: event.newDesc, created_at: event.createdAt)
      );
      if (check) {
        var currentData = await dbHelper.getAllNotesFromDB();
        emit(LoadedState(mData: currentData));
      } else {
        emit(ErrorState(error: "Note not add"));
      }
    },);

    ///get initial data
    on<getInitialData>((event, emit) async{
      var currentData = await dbHelper.getAllNotesFromDB();
      if(currentData.isNotEmpty){
        emit(LoadedState(mData: currentData));
      }else{
        emit(LoadedState(mData: []));
      }
    },);

    ///delete data
    on<deleteData>((event, emit) async{
      bool check = await dbHelper.deleteNote(id : event.id);
      if(check){
        var currentData = await dbHelper.getAllNotesFromDB();
        emit(LoadedState(mData: currentData));
      }else{
        emit(ErrorState(error: "Note not deleted"));
      }
    },);

    ///update data
    on<updateData>((event, emit) async{
      bool check = await dbHelper.updateNote(
          updatedTitle: event.updatedTitle,
          updatedDesc: event.updatedDesc,
          updatedAt: event.updatedAt,
          id: event.id
      );
      if(check){
        var currentData = await dbHelper.getAllNotesFromDB();
        emit(LoadedState(mData: currentData));
      }else{
        emit(ErrorState(error: "Note not updated"));
      }
    },);
  }





}