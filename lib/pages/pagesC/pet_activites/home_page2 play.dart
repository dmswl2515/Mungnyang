import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:totalexam/controllers/task_controller.dart';
import 'package:totalexam/models/task.dart';
import 'package:totalexam/reference/theme.dart';
import 'package:totalexam/ui/widgets/button.dart';
import 'package:totalexam/ui/widgets/input_field.dart';


class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime="9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  //알림
  int _selectedRemind = 5;  
  List<int> remindList = [
    5,
    10,
    15,
    20
  ];

  //반복
  String _selectedRepeat = "없음";  
  List<String> repeatList = [
    "없음",
    "매일",
    "매주",
    "매달"
  ];

  //색깔 선택
  int _selectedColor=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor, //다크모드 한 채로 일정추가 페이지로 이동하면 다크모드 그대로 적용됨
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top : 10, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("일정 등록",
                  style: HeadingStyle,),
              MyInputField(title: "제목", hint: "제목을 입력해주세요", controller: _titleController,),
              MyInputField(title: "메모", hint: "메모를 입력해주세요", controller: _noteController,),
              MyInputField(title: "날짜", hint: DateFormat.yMd().format(_selectedDate),
                widget : IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                    color: Colors.grey,
                  onPressed: () {
                    _getDateFromUser();
                  }, 
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "시작 시간",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true); 
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ), 
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                      title: "종료 시간",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false); 
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ), 
                    ),
                  ),
                ]
              ),
              MyInputField(title: "알림", hint: "$_selectedRemind분 전에 알림",
                widget: DropdownButton(
                  icon: Icon( Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {   //value를 바꾸면 바뀐 값을 전달
                    setState(() { 
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString())
                    );
                  }
                  ).toList(), 
                ),
              ),
              MyInputField(title: "반복", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon( Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {   //value를 바꾸면 바뀐 값을 전달
                    setState(() { 
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!, style : TextStyle(color: Colors.grey))
                    );
                  }
                  ).toList(), 
                ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "저장하기", 
                    onTap: () => _validatedDate()),
                ],
              )
            ],
          )
        ),
      ),
    );

  }

  _addTaskToDb() async {
   int value = await _taskController.addTask(
      task:Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime : _startTime,
        endTime: _endTime,
        remind : _selectedRemind,
        repeat : _selectedRepeat,
        color: _selectedColor,  //선택된 색상
        isCompleted: 0,
      )
    );
    print("my id is"+"$value");
  }

  //유효성 검증
  _validatedDate(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      //데이터베이스
      _addTaskToDb();
      Get.back(result: _selectedDate);  // 선택된 날짜를 반환하며 페이지를 돌아가기
    } else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("필수사항입니다", "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded,
                   color: Colors.red,)
      );
    }
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("색",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
      Wrap(
        children:  List<Widget>.generate(
          3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor=index; //인덱스를 이용해서 선택여부를 표시
                    print("$index");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right : 8.0),
                  child: CircleAvatar (
                    radius: 14,
                    backgroundColor: index==0? primaryClr:index==1?pinkClr:yellowClr,
                    child: _selectedColor==index?Icon(Icons.done,
                                color: Colors.white,
                                size: 16
                    ):Container(),
                  ),
                ),
              );
            }
        ),
      )],
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: 
      //여기에 뒤로가기 버튼 있었으면 좋겠어
      GestureDetector(
        onTap : () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
                    size: 20,
                    color: Get.isDarkMode? Colors.white:Colors.black
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: 
            AssetImage("assets/images/dogcat.png"
           ),
        ),
      SizedBox(width: 20,)
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2015), 
      lastDate: DateTime(2030),
    );

    if(_pickerDate!=null){
      setState(() {
      _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is is wrong");
      
    }
  }

  //사용자 시간 가져오기
  _getTimeFromUser({required bool isStartTime}) async  {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("Time canceld");
    } else if(isStartTime == true) {
      setState(() {
      _startTime = _formatedTime;
      });
    } else if(isStartTime == false) {
      setState(() {
      _endTime = _formatedTime;
      });
      
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context, 
      initialTime: TimeOfDay(   //시간과 분단위로 표시
        //_startTime --> 10:30 AM
        hour: int.parse(_startTime.split(":")[0]), 
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      )
    );
  }
}