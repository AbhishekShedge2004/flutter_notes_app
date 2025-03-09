import 'package:database_new/model/note_model.dart';

abstract class dbBlocState{}

class InitialState extends dbBlocState{}

class LoadingState extends dbBlocState{}

class LoadedState extends dbBlocState{
  List<NoteModel> mData;
  LoadedState({required this.mData});
}

class ErrorState extends dbBlocState{
  String error;
  ErrorState({required this.error});
}
