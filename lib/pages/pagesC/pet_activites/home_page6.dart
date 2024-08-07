import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:totalexam/controllers/task_controller.dart';
// import 'package:newscheduler/services/notification_services.dart';  //알림
import 'package:totalexam/services/theme_services.dart';
import 'package:totalexam/reference/theme.dart';
import 'package:totalexam/ui/widgets/add_task_bar.dart';
import 'package:totalexam/ui/widgets/button.dart';

class HospitalPage extends StatelessWidget {
  HospitalPage({super.key, required String title});

// GetX의 상태 관리를 위한 TaskController 인스턴스를 찾습니다.
  // final TaskController _taskController = Get.find();
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  final TaskController _taskController = Get.put(TaskController()); // TaskController 인스턴스 생성




  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // notifyHelper = NotifyHelper();
  //   // notifyHelper.initializeNotification();
  //   // //notifyHelper.requestIOSPermissions();
  //   // notifyHelper._requestIOSPermissions();
  // }

  @override
  Widget build(BuildContext context) {
    _taskController.getTasks(); // 데이터 로딩

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          // DB 정보 표시를 위한 부분
          _buildTaskList(), // _buildTaskList 호출
        ],
      ),
    );
  }
 

  // 날짜 변경 시 호출되는 메서드
  void _onDateChanged(DateTime date) {
      _selectedDate = date;
      // 선택한 날짜에 맞는 일정만 필터링
      _taskController.getTasksByDate(date); // 선택한 날짜에 맞는 태스크를 필터링합니다.
  }

  _buildTaskList() {
    return Expanded(
      child: Obx(() {
        // filteredTaskList가 변경될 때마다 UI를 업데이트합니다.
        if (_taskController.filteredTaskList.isEmpty) {
          return Center(child: Text('등록된 일정이 없습니다'));
        }
        return ListView.builder(
          itemCount: _taskController.filteredTaskList.length,
          itemBuilder: (context, index) {
          final task = _taskController.filteredTaskList[index];

          // 색상 선택 
        Color backgroundColor = task.color == 0 ? primaryClr : 
                                task.color == 1 ? pinkClr : 
                                task.color == 2 ? yellowClr : Colors.grey; // 기본 색상
            
            return Container(
              margin: EdgeInsets.symmetric(vertical : 8, horizontal : 5),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(    //그림자 
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius:4,
                    offset : Offset(0, 2), //Changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(         //일정 제목
                    task.title ?? 'No Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(  //시간
                    children: [
                      Icon(Icons.access_time, color: Colors.white,),
                      SizedBox(width: 5),
                      Text(   //시작시간
                        '${task.startTime ?? 'No StartTime'}',
                        style: TextStyle(fontSize: 16, color: Colors.white70
                        ),
                      ),
                      Text(   // -
                        ' - ',
                        style: TextStyle(fontSize: 16, color: Colors.white70
                        ),
                      ),
                      Text(   //끝나는 시간
                        '${task.endTime ?? 'No endTime'}',
                        style: TextStyle(fontSize: 16, color: Colors.white70
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        task.note ?? 'no Note',
                        style : TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      }),
    );
  }

  _addDateBar(){
    return Container(
            // margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),    //초기 세팅 날짜
              selectionColor: primaryClr,       //오늘 날짜 표시하는 색깔
              selectedTextColor: Colors.white,  //기본 글씨 색깔
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(               //날짜(숫자) 관련 textstyle
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(               //날짜(숫자) 관련 textstyle
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(               //날짜(숫자) 관련 textstyle
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
                ),
              ),
              onDateChange: (date){
                // _selectedDate=date;
                _onDateChanged(date);
              },
            ),
          ) ;
  }

  _addTaskBar(){
     return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,
                      ),  //오늘 날짜 
                      Text("Today",
                        style: HeadingStyle,
                      ),
                    ],
                  ),
                ),
                 MyButton(
            label: "+ 일정추가",
            onTap: () {
              // AddTaskPage로 이동하고, 결과가 true일 때 태스크 목록을 갱신합니다.
              Get.to(() => AddTaskPage())?.then((result) {
                if (result == true) {
                  _taskController.getTasks(); // 새로고침을 위해 모든 태스크를 다시 조회합니다.
                }
              });
            },
          ),
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      // backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 20, color: Get.isDarkMode ? Colors.white : Colors.black),
      ),  
      actions: [
        GestureDetector(
          onTap : () {
            ThemeServices().switchTheme();
            notifyHelper.displayNotification(
              title: "Theme Changed",
              body : Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
            );

            notifyHelper.scheduledNotification();
          },
          child: Icon(Get.isDarkMode?Icons.sunny:Icons.nightlight_round,
                      size: 20,
                      color: Get.isDarkMode? Colors.white:Colors.black
          ),
        ),
        const SizedBox(width: 20),
        const CircleAvatar(
          backgroundImage: 
            AssetImage("assets/images/dogcat.png"
           ),
           backgroundColor: Colors.white,
        ),
      const SizedBox(width: 20,)
      ],
    );
  }
}