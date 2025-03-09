import 'package:database_new/ui/add_note_page.dart';
import 'package:database_new/bloc/db_bloc.dart';
import 'package:database_new/bloc/db_bloc_events.dart';
import 'package:database_new/db/db_helper.dart';
import 'package:database_new/provider/db_provider.dart';
import 'package:database_new/main.dart';
import 'package:database_new/model/note_model.dart';
import 'package:database_new/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/db_bloc_state.dart';
import '../cubit/db_cubit.dart';
import '../cubit/db_state.dart';

class HomePage extends StatelessWidget {

  //DBHelper dbHelper = DBHelper.getInstance();
  // TextEditingController titleController = TextEditingController();
  // TextEditingController descController = TextEditingController();

  List<NoteModel> allNotes = [];

  DateFormat mFormat = DateFormat.yMd();

  // @override
  // void initState() {
  //   super.initState();
  //   // getMyNotes();
  // }

  @override
  Widget build(BuildContext context) {

    // context.read<DBProvider>().getInitialNotes();
    context.read<dbBloc>().add(getInitialData());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home'),
            ElevatedButton(onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool check = await prefs.setInt("UID", 0);
              if(check){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                },));
              }
            }, child: Text("Logout"))
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: BlocBuilder<dbBloc,dbBlocState>(
        builder: (context,state) {

          if(state is LoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is ErrorState){
            return Center(
              child: Text("Error: ${state.error}"),
            );
          }
          if(state is LoadedState){
            allNotes = state.mData; //value.getAllNotesFromProvider()

            return allNotes.isNotEmpty
            //Notes List Builder
                ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {

                  //Note View
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Card(
                      elevation: 7,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(allNotes[index].title)),
                            Text(mFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index].created_at))),style: TextStyle(fontSize: 10),)
                          ],
                        ),
                        subtitle: Text(allNotes[index].desc),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              //update
                              IconButton(
                                  onPressed: () {
                                    var title = allNotes[index].title;
                                    var desc = allNotes[index].desc;
                      
                                    // showModalBottomSheet(context: context, builder: (context) {
                                    //   return getBottomSheetUI(isUpdate: true, id: allNotes[index][DBHelper.COLUMN_NOTE_ID]);
                                    // },);
                      
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return AddNotePage(isUpdate: true, id: allNotes[index].id!, title: title, desc: desc,);
                                    },));
                      
                                  },
                                  icon: Icon(Icons.edit)),
                      
                              //delete
                              IconButton(
                                  onPressed: () async{
                                    context.read<dbBloc>().add(deleteData(id: allNotes[index].id!));
                                    //context.read<DBCubit>().deleteData(id: allNotes[index][DBHelper.COLUMN_NOTE_ID]);
                                    // bool check = await dbHelper.deleteNote(id: allNotes[index][DBHelper.COLUMN_NOTE_ID]);
                                    // if(check){
                                    //   getMyNotes();
                                    // }
                                  },
                                  icon: Icon(
                                    Icons.delete, color: Colors.red,)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Notes yet'),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AddNotePage();
                        },));
                        // showModalBottomSheet(
                        //     isDismissible: false,
                        //     enableDrag: false,
                        //     context: context,
                        //     builder: (_) {
                        //       return getBottomSheetUI();
                        //     });
                      },
                      child: Text('Add First Note'))
                ],
              ),
            );
          }

          return Container();

        },
      ),
      floatingActionButton: BlocBuilder<dbBloc,dbBlocState>(builder: (context, state) {
        if(state is LoadedState){
          if(state.mData.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () async {
                // titleController.clear();
                // descController.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNotePage();
                },));
                // showModalBottomSheet(
                //     isDismissible: false,
                //     enableDrag: false,
                //     context: context,
                //     builder: (_) {
                //       return getBottomSheetUI();
                //     });
              },
              child: Icon(Icons.add),
            );
          }
        }
        return Container();

      },)
    );
  }

  // void getMyNotes() async {
  //   allNotes = await dbHelper.getAllNotes();
  //   setState(() {});
  // }


  //Note Input Form
// Widget getBottomSheetUI({bool isUpdate = false, int id = 0}){
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(11),
//       child: Column(
//         children: [
//           Text(
//             isUpdate ? "Update Note" : 'Add Note',
//             style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 21,
//           ),
//           TextField(
//             controller: titleController,
//             decoration: InputDecoration(
//               hintText: "Enter title here..",
//               label: Text('Title'),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius:
//                   BorderRadius.circular(11)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius:
//                   BorderRadius.circular(11)),
//             ),
//           ),
//           SizedBox(
//             height: 11,
//           ),
//           TextField(
//             controller: descController,
//             minLines: 2,
//             maxLines: 3,
//             decoration: InputDecoration(
//               label: Text('Description'),
//               hintText: "Enter desc here..",
//               enabledBorder: OutlineInputBorder(
//                   borderRadius:
//                   BorderRadius.circular(11)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius:
//                   BorderRadius.circular(11)),
//             ),
//           ),
//           SizedBox(
//             height: 11,
//           ),
//           Row(
//             children: [
//               Expanded(
//                   child: OutlinedButton(
//                       onPressed: () async {
//
//                         if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
//
//                           bool check = false;
//
//                           if(isUpdate){
//                             check = await dbHelper.updateNote(
//                                 updatedTitle: titleController.text,
//                                 updatedDesc: descController.text,
//                                 updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
//                                 id: id,
//
//                             );
//                           }else {
//                             check = await dbHelper.addNote(
//                                 title: titleController.text,
//                                 desc: descController.text,
//                                 createdAt: DateTime.now().millisecondsSinceEpoch.toString()
//                             );
//                           }
//
//                           if (check) {
//                             getMyNotes();
//                             Navigator.pop(context);
//                           }
//
//                         }
//                       },
//                       child: Text(isUpdate ? "Update" : 'Add'))),
//               SizedBox(
//                 width: 11,
//               ),
//               Expanded(
//                   child: OutlinedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('Cancel'))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

}