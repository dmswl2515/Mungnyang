import 'package:totalexam/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName ="tasks";

  static Future<void> initDb() async {
    if(_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db'; //db 생성
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title STRING, note TEXT, date STRING, "
              "startTime STRING, endTime STRING, "
              "remind INTEGER, repeat STRING, "
              "color INTEGER, "
              "isCompleted INTEGER)",
          );
        },
      );
    } catch(e) {
      print(e); 
    }
  }
  
  //데이터 삽입
  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson())??1;  //db가 null인지 확인
  }

  //데이터 선택 메서드 
   static Future<List<Task>> query() async {
    final List<Map<String, dynamic>> tasks = await _db!.query(_tableName); // 모든 행 선택
    return tasks.map((task) => Task.fromJson(task)).toList(); // Map을 Task 객체로 변환
  }

   // 특정 작업을 삭제하는 메서드
  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  // 특정 작업을 업데이트하는 메서드
  static Future<int> update(Task task) async {
    return await _db!.update(_tableName, task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }
}
