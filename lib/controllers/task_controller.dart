import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:totalexam/db/db_helper.dart';
import 'package:totalexam/models/task.dart';

class TaskController extends GetxController{
// 작업 목록을 저장하는 관찰 가능한 변수
  var taskList = <Task>[].obs;
  var filteredTaskList = <Task>[].obs;  // 추가된 필터링된 일정 리스트

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  Future<int> addTask({Task? task}) async{
    return await DbHelper.insert(task);  
    // getTasks();  // 작업을 추가한 후 모든 작업을 다시 조회
    // return result;
  }

   // 모든 작업을 조회하는 메서드
  Future<void> getTasks() async {
    List<Task> tasks = await DbHelper.query(); // DB에서 태스크 불러오기
    taskList.assignAll(tasks); // 태스크 리스트 업데이트
    filteredTaskList.assignAll(tasks); // 초기 필터링된 리스트는 전체 리스트와 동일
  }

  // 특정 작업을 삭제하는 메서드
  void deleteTask(Task task) async {
    await DbHelper.delete(task);
    getTasks();  // 작업을 삭제한 후 모든 작업을 다시 조회
  }

  // 특정 작업을 업데이트하는 메서드
  void updateTask(Task task) async {
    await DbHelper.update(task);
    getTasks();  // 작업을 업데이트한 후 모든 작업을 다시 조회
  }

  // 날짜에 따라 작업을 필터링하는 메서드
  void getTasksByDate(DateTime date) {
    var formattedDate = DateFormat.yMd().format(date); // 날짜를 문자열로 포맷
    var filteredTasks = taskList.where((task) => task.date == formattedDate).toList();
    filteredTaskList.assignAll(filteredTasks); // 필터링된 리스트 업데이트
  }
}