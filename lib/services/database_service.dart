import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Models/user_model.dart';

class Db {

static Db? _db;

Db._();

factory Db(){
_db??=Db._();
return _db!;

}


Future<Database> get database async{

var path =await getDatabasesPath();

return await openDatabase(join(path, 'local.db'), onCreate: (db, version)async {
await  db.execute(User.CREATETABLE);
  await db.execute(Tasks.CREATE_TABLE);
  }, version: 2);

}

Future<List<Tasks>> fetchTasks()async{

var db = await database;

var data=await db.query(Tasks.TASK_TABLE_NAME);

return data.map((e) => Tasks.fromMap(e),).toList();

}


Future<int> insertTask(Tasks tasks)async{

var db= await database;

return await db.insert(Tasks.TASK_TABLE_NAME, tasks.toMap());

}


Future<bool> deleteTask(Tasks tasks)async{
var db = await database;

var isDeleted=await db.delete(Tasks.TASK_TABLE_NAME, where: '${Tasks.COL_PRIMARYKEY}=?', whereArgs: [tasks.taskPrimaryKey]);
return isDeleted>0;
}

Future<bool> updateTask(Tasks tasks)async{

var db = await database;

var isUpdated= await db.update(Tasks.TASK_TABLE_NAME, tasks.toMap(), where: '${Tasks.COL_PRIMARYKEY}=?', whereArgs: [tasks.taskPrimaryKey]);
return isUpdated>0;
}


Future<User> fetchUser()async{

var db= await database;

var user=await db.query(User.TABLE_NAME,limit: 1 );

if (user.isNotEmpty) {
  return User.fromMap(user[0]);
}else{
  return throw Exception('Null data in List');
}
}


Future<bool> insertUser(User user)async{
var db = await database;

var isInserted= await db.insert(User.TABLE_NAME, user.toMap());
return isInserted>=0;
}

Future<bool> updateUser(User user)async{

var db =await database;
var isUpdated=await db.update(User.TABLE_NAME, user.toMap());

return isUpdated>=0;
}



Future<void> clearAllData() async {
  final path = await getDatabasesPath();
  final dbPath = join(path, 'local.db');

  
  await deleteDatabase(dbPath);

  
  final sp = await SharedPreferences.getInstance();
  await sp.clear();
}

  
}