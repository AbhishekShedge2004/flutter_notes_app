abstract class dbBlocState{}

class InitialState extends dbBlocState{}

class LoadingState extends dbBlocState{}

class LoadedState extends dbBlocState{
  List<Map<String,dynamic>> mData;
  LoadedState({required this.mData});
}

class ErrorState extends dbBlocState{
  String error;
  ErrorState({required this.error});
}
