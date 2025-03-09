import 'package:database_new/model/note_model.dart';
import 'package:database_new/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  ///singleton class
  /// 1 creating a private constructor
  DBHelper._();

  /// 2 globally distribute
  static DBHelper getInstance() => DBHelper._();


  ///getDB

  Database? mDB;

  ///table
  static final String TABLE_NOTE_NAME = "note";
  static final String USER_TABLE = "users";

  ///note columns
  static final String COLUMN_NOTE_ID = "note_id";
  static final String COLUMN_NOTE_TITLE = "note_title";
  static final String COLUMN_NOTE_DESC = "note_desc";
  static final String COLUMN_NOTE_CREATED_AT = "note_created_at";

  ///users columns
  static final String COLUMN_USER_ID = "uId";
  static final String COLUMN_USER_NAME = "uName";
  static final String COLUMN_USER_EMAIL = "uEmail";
  static final String COLUMN_USER_PASS = "uPass";

  Future<Database> getDB() async{
    mDB ??= await openDB();
    return mDB!;
    // if(mDB!=null){
    //   return mDB!;
    // } else {
    //   mDB = await openDB();
    //   return mDB!;
    // }
  }

  Future<Database> openDB() async {

    var appDir = await getApplicationDocumentsDirectory();
    var dbPath = join(appDir.path, "notes.db");


    return openDatabase(dbPath, version: 1, onCreate: (db, version){

      /// create all your tables here
      db.execute(
          "create table $TABLE_NOTE_NAME ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATED_AT text)"
      );

      db.execute(
        "create table $USER_TABLE ( $COLUMN_USER_ID integer primary key autoincrement, $COLUMN_USER_NAME text, $COLUMN_USER_EMAIL text unique, $COLUMN_USER_PASS text )"
      );

    });

  }

  ///db functions (queries)
  ///insert
  Future<bool> addNote(NoteModel newNote) async{
    Database db = await getDB();

    var uid = await getUID();
    newNote.user_id = uid;

    int rowsEffected = await db.insert(TABLE_NOTE_NAME, newNote.toMap());
    return rowsEffected>0;

  }

  ///fetch
  Future<List<NoteModel>> getAllNotesFromDB() async{
    Database db = await getDB();

    var uid = await getUID();

    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE_NAME, where: "$COLUMN_USER_ID = ?", whereArgs: ["$uid"]);

    List<NoteModel> mNotes = [];

    for(Map<String,dynamic> eachNote in mData){
      NoteModel eachNoteModel = NoteModel.fromMap(eachNote);
      mNotes.add(eachNoteModel);
    }

    return mNotes;
  }

  ///update
  Future<bool> updateNote({ required String updatedTitle, required String updatedDesc, required String updatedAt, required int id}) async{
    var db = await getDB();

    int rowsEffected = await db.update(TABLE_NOTE_NAME, {
      COLUMN_NOTE_TITLE : updatedTitle,
      COLUMN_NOTE_DESC : updatedDesc,
      COLUMN_NOTE_CREATED_AT : updatedAt
    }, where: "$COLUMN_NOTE_ID = $id");

    return rowsEffected>0;
  }

  //delete
  Future<bool> deleteNote({required int id}) async{
    var db = await getDB();

    int rowsEffected = await db.delete(TABLE_NOTE_NAME, where: "$COLUMN_NOTE_ID = ?", whereArgs: ["$id"]);

    return rowsEffected>0;
  }

  ///Queries for USER

  ///user signup
  Future<bool> addNewUser(UserModel newUser) async{
    Database db = await getDB();
    bool haveAccount = await checkIfEmailAlreadyExists(newUser.uEmail);
    bool accCreated = false;
    if(!haveAccount){
       int rowsEffected = await db.insert(USER_TABLE, newUser.toMap());
       accCreated = rowsEffected>0;
    }

    return accCreated;

  }

  //user check email exists
  Future<bool> checkIfEmailAlreadyExists(String email) async{
    Database db = await getDB();
    var mData = await db.query(USER_TABLE, where: "$COLUMN_USER_EMAIL = ?", whereArgs: [email]);

    return mData.isNotEmpty;
  }

  ///user login
  Future<bool> authenticateUser(String email, String pass) async{
    Database db = await getDB();

    var mData = await db.query(USER_TABLE, where: "$COLUMN_USER_EMAIL = ? AND $COLUMN_USER_PASS = ?", whereArgs: [email, pass]);

    if(mData.isNotEmpty){
      setUID(UserModel.fromMap(mData[0]).uId!);
    }
    return mData.isNotEmpty;
  }

  ///get UID
  Future<int> getUID() async{
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("UID")!;
  }

  ///set UID
  void setUID(int uid) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt("UID", uid);
  }



}