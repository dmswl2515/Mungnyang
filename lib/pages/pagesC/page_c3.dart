import 'package:firebase_storage/firebase_storage.dart';
import 'package:totalexam/pages/pagesC/pet_activites/eat_page.dart';
import 'package:totalexam/pages/pagesC/pet_activites/edit_page.dart';
import 'package:totalexam/pages/pagesC/pet_activites/home_page1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../reference/text_provider.dart';
import '../../reference/utils.dart';
import 'package:intl/intl.dart';
import 'pet_activites/home_page2 play.dart';  //시간 오전, 오후 나타낼 수 있는 패키지
import 'package:cloud_firestore/cloud_firestore.dart';

class PageC3 extends StatefulWidget {
  
  const PageC3({Key? key, required String title}) : super(key: key);

  @override
  _PageC3State createState() => _PageC3State();
}

class _PageC3State extends State<PageC3> with SingleTickerProviderStateMixin {
  //이미지 밑에 표시되는 이름
  final List<String> imageNames = [
    '식사/간식',
    '배변',
    '놀이',
    '산책',
    '양치/목욕',
    '미용',
    '병원',
    '약',
    '호흡수',
    '심박수',
  ];

  //현재 선택된 인덱스를 저장할 변수
  int? _currentSelectedIndex;
  
  //버튼을 누르면 page1에 인덱스 전달
  void _updateTextProvider(int index) {
    _currentSelectedIndex = index;
    print('_currentSelectdIndex: $_currentSelectedIndex');
    Provider.of<TextProvider>(context, listen: false).updateIndex(index);
  }

   // 클릭한 이미지의 정보를 저장하는 리스트
  List<Map<String, dynamic>> allClickedImages = [];   //전체 데이터
  List<Map<String, dynamic>> clickedImages = [];      //선택된 날짜의 데이터

  //캘린더
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //선택된 반려동물의 이름을 기본값으로 설정
  String selectedPetName = "all_pets";  

  @override
  void initState() {
    super.initState();
    _fetchFromFirestore();  // Firebase에서 데이터 가져오기
  }

  //데이터 가져오기
  Future<void> _fetchFromFirestore() async {
  try {
    //pet_activites 컬렉션에서 데이터를 가져오기 위해 query 객체 생성
    Query query = FirebaseFirestore.instance.collection('pet_activities');
    print('query: $query');

    // 선택된 petName이 있을 경우 petName과 일치하는 데이터 가져오기
    if (selectedPetName != null) {
      print('Selected pet Name: $selectedPetName'); 
      query = query.where('petName', isEqualTo: selectedPetName);
    }
    
    //쿼리에 해당하는 문서를 snapshot으로 가져오기
    final snapshot = await query.get();
    final List<Map<String, dynamic>> loadedData = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // 'date' 필드를 DateTime 형식으로 변환 (Timestamp일 경우만 변환)
      final date = data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(); // date가 null일 경우 기본값으로 현재 시간 사용
      
      return {
        'id': doc.id,
        'index': imageNames.indexOf(data['category']),
        'date': data['date'],  // Timestamp를 DateTime으로 변환
        'title': data['title'],
        'memo': data['memo'] ?? '자세한 정보를 입력해주세요',
        'startTime': data['startTime'],
        'endTime': data['endTime'],
        'petName': data['petName'],
        'timestamp': data['timestamp'],
        
      };
    }).toList();

    print('Data loaded from Firestore: $loadedData'); // 데이터 로드 확인
    
    allClickedImages = loadedData;
    _filterImagesByDate(_selectedDay ?? DateTime.now());
    print('Data fetched and setState called successfully');
  } catch (e) {
    print('Error fetching data from Firestore: $e');
  }
}

  // 날짜 선택 시 호출되는 함수
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        
        // 선택한 날짜에 해당하는 이미지만 필터링
        _filterImagesByDate(selectedDay);
      });
    }
  }

  // 선택한 날짜에 해당하는 이미지만 필터링하는 함수
  void _filterImagesByDate(DateTime date) {
  print('Filtering images for date: $date and petName: $selectedPetName');
  print('All clicked images before filtering: $allClickedImages');

  setState(() {
    clickedImages = allClickedImages.where((image) {
      final imageDate = DateTime.parse(image['date']); // 문자열을 DateTime으로 변환
      final bool isSameDate = imageDate.year == date.year &&
                              imageDate.month == date.month &&
                              imageDate.day == date.day;

      if (selectedPetName != null) {
        return isSameDate && image['petName'] == selectedPetName;
      } else {
        return isSameDate;
      }

    }).toList();
    print('Clicked images filtered: $clickedImages'); // 필터링된 데이터 확인
  });
}

  Future<void> _saveToFirestore(int index, DateTime time) async {
  try {
    await FirebaseFirestore.instance.collection('pet_activities').add({
      'category': imageNames[index],
      'title': imageNames[index],
      'memo': '자세한 정보를 입력해주세요',
      'date': DateFormat('yyyy-MM-dd').format(time),
      'startTime': DateFormat('h:mm a').format(time),
      'endTime': "09:30 PM",
      'timestamp': Timestamp.fromDate(time),
      'petName': selectedPetName ?? 'all_pets', // 선택된 반려동물이 있으면 해당 이름을 저장하고, 없으면 'all_pets'로 저장
    });
    _fetchFromFirestore(); // Firestore에서 데이터를 다시 가져옴
  } catch (e) {
    print('Error saving activity to Firestore: $e');
  }
}

  // 항목 삭제 함수
  Future<void> _deleteItem(int index) async {
  final id = clickedImages[index]['id'];

  try {
    await FirebaseFirestore.instance.collection('pet_activities').doc(id).delete();
    print('Activity deleted from Firestore with ID: $id');
    print('index: $index');
    
    setState(() {
      clickedImages.removeAt(index);
      if(_currentSelectedIndex == index)
      {
        print('_currentSelectedIndex: $_currentSelectedIndex');
        if(clickedImages.isNotEmpty) {
          int newIndex = clickedImages.length - 1 ;
          _updateTextProvider(newIndex); //이전의 인덱스를 provider에 전달
          
          print('newIndex: $newIndex');
          print('_updateTextProvider: $_updateTextProvider');

        } else {
          // 만약 clickedImages가 비어있다면, provider에 null을 전달
          Provider.of<TextProvider>(context, listen: false).updateIndex(-1);
        }
      }
    });
  } catch (e) {
    print('Error deleting activity from Firestore: $e');
  }
}

  //페이지수정
  Future<void> _navigateToPage(int clickedIndex, int index) async {
  var data = {
    'id': clickedImages[index]['id'],
    'title': clickedImages[index]['title'],
    'memo': clickedImages[index]['memo'],
    'startTime': clickedImages[index]['startTime'] ?? '09:00',
    'endTime': clickedImages[index]['endTime'] ?? '21:30',
    'date': DateTime.now(),
  };

  bool? result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditPage(
        documentId: clickedImages[index]['id'],
        initialCategory: imageNames[clickedIndex],
        initialTitle: clickedImages[index]['title'],
        initialMemo: clickedImages[index]['memo'],
        initialStartTime: DateFormat('HH:mm').parse(data['startTime']),
        initialEndTime: DateFormat('HH:mm').parse(data['endTime']),
      ),
    ),
  );

  print('Result from EditPage: $result'); // 반환값 확인

  if (result == true) {
    print("Fetching data from Firestore...");
    await _fetchFromFirestore(); // Firestore에서 데이터를 다시 가져옴
  }
}

void _testFirestoreQuery() async {
  final snapshot = await FirebaseFirestore.instance.collection('pet_activities').where('date', isEqualTo: '2024-08-01').get();
  final documents = snapshot.docs.map((doc) => doc.data()).toList();
  print('Test Firestore Query: $documents');
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        centerTitle: true,  //가운데 정렬
        title: const Text('반려동물케어'),
        backgroundColor: Colors.deepPurple[200],
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.deepPurple[200],
                context: context, 
                builder: (BuildContext context) {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('pets').get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('반려동물 정보가 없습니다.'));
                      }

                      return Container(
                        padding: EdgeInsets.all(20),
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '반려동물 선택',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('케어할 반려동물을 선택해주세요'),
                            SizedBox(height: 20),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // 한 줄에 3개의 항목을 배치
                                  crossAxisSpacing: 10.0, // 아이템 사이의 가로 간격
                                  mainAxisSpacing: 10.0, // 아이템 사이의 세로 간격
                                  childAspectRatio: 1, // 아이템의 가로세로 비율
                                ),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var doc = snapshot.data!.docs[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPetName = doc['name'];  //선택된 반려동물의 이름을 저장 
                                      });
                                      Navigator.pop(context);  // 선택 후 모달 닫기
                                    },
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(doc['image']),
                                          radius: 30, // 프로필 이미지 크기
                                        ),
                                        SizedBox(height: 5),
                                        Text(doc['name']),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, 
                                  child: Text('취소'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              );
            },
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/images/부비.png'), 
              radius: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected, // 수정된 콜백 사용
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              //수평
              scrollDirection: Axis.horizontal,
              shrinkWrap:
                  true, //ListView, GridView, PageView와 같은 스크롤 가능한 위젯의 속성 중 하나, 해당 위젯의 크기를 자식 위젯의 크기에 맞춰 축소할지 여부를 결정,스크롤 가능한 위젯은 부모 위젯의 남은 공간을 모두 차지하려고 함.
              itemCount: 10, // 아이템 개수를 1개가 아닌 10개로 설정
              itemBuilder: (context, index) {
                return Padding(
                  //위젯 간에 간격 배정
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Image $index clicked');
                          _saveToFirestore(index, _selectedDay ?? DateTime.now()); // _selectedDay가 null일 경우 현재 날짜로 저장
                          _updateTextProvider(index); // Provider 상태 업데이트
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: AssetImage('assets/images2/image$index.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5), // 이미지와 텍스트 사이의 간격
                      Text(imageNames[index], // 이미지 아래 이름 표시
                          style: const TextStyle(fontSize: 12)), // 글자 크기 설정
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              //디폴드 값이 수직
              shrinkWrap:
                  true, //ListView, GridView, PageView와 같은 스크롤 가능한 위젯의 속성 중 하나, 해당 위젯의 크기를 자식 위젯의 크기에 맞춰 축소할지 여부를 결정,스크롤 가능한 위젯은 부모 위젯의 남은 공간을 모두 차지하려고 함.
              itemCount: clickedImages.length, // 클릭한 인덱스의 길이만큼 설정,
              itemBuilder: (context, index) {
                // int clickedIndex = clickedIndices[index];
                int clickedIndex = clickedImages[index]['index'];
                DateTime clickedTime = DateTime.parse(clickedImages[index]['date']);
                String formattedTime = DateFormat('h:mm a').format(clickedTime); // 오전/오후 시간 형식(시간:분 오전/오후)
                String timeWithParentheses = '($formattedTime)'; // 시간에 괄호 추가

                return buttonSlider(index, clickedIndex, timeWithParentheses); 
              },
            ),
          ),
        ],
      ),
    );
  }

  //수정, 삭제 슬라이더
  Slidable buttonSlider(int index, int clickedIndex, String timeWithParentheses) {
  return Slidable(
    key: ValueKey(index),
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () => _deleteItem(index)),
      children: [
        SlidableAction(
          onPressed: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  String startTimeStr = clickedImages[index]['startTime'] ?? '09:00 AM';
                  String endTimeStr = clickedImages[index]['endTime'] ?? '09:30 PM';

                  // 24시간 형식을 12시간 형식으로 변환
                  DateTime startTime = DateFormat('HH:mm').parse(startTimeStr);
                  DateTime endTime = DateFormat('HH:mm').parse(endTimeStr);

                  return EditPage(
                    documentId: clickedImages[index]['id'],
                    initialCategory: imageNames[clickedIndex],
                    initialTitle: clickedImages[index]['title'],
                    initialMemo: clickedImages[index]['memo'],
                    initialStartTime: startTime,
                    initialEndTime: endTime,
                  );
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          backgroundColor: Colors.deepPurple.shade400,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: '수정',
        ),
        SizedBox(width: 5,),
        SlidableAction(
          onPressed: (context) => _deleteItem(index), // 삭제 버튼 클릭 시
          borderRadius: BorderRadius.circular(8.0),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: '삭제',
        ),
      ],
    ),
    child: _buttonStyle(clickedIndex, timeWithParentheses, index),
  );
}

  //clicked button 스타일
  Padding _buttonStyle(int clickedIndex, String timeWithParentheses, int index) {
    String memo = clickedImages[index]['memo'] ?? '자세한 정보를 입력해주세요';  // 메모가 없을 경우 기본 텍스트 설정

    return Padding(
                //위젯 간에 간격 배정
                padding: const EdgeInsets.all(6.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(12.0) //사각형 모서리 둥글게   
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(  //이미지 테두리
                              border: Border.all(color: const Color.fromARGB(0, 0, 0, 0), width: 1.0), // container안에 사각형 테두리
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color.fromARGB(0, 255, 255, 255),  //이미지 테두리 배경색
                            ),
                            child: ClipRRect( //이미지
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images2/image$clickedIndex.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),  
                          const SizedBox(width: 15), // 이미지와 텍스트 사이의 간격
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(imageNames[clickedIndex], 
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                                    const SizedBox(width: 5),
                                    Text(
                                      timeWithParentheses,    //시간 오전, 오후 표현할 수 있음
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text( memo,
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ],
                          ),
                          Spacer(), // 텍스트와 버튼 사이의 공간을 채움
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(50, 90), // 너비 50, 높이 50
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent, // 그림자도 투명하게 설정
                            ),
                            child: const Text('>',
                              style: TextStyle(fontSize: 24, color : Colors.black),),
                              onPressed: () {
                                 _navigateToPage(clickedIndex, index); // 편집 화면으로 이동
                              },
                          ),
                        ]
                      ),
                    ),
                  ),
                );
  }

  //반려동물 이미지 가져오기
  Future<String> _getProfileImageUrl(String imagePath) async {
  // Firebase Storage에서 이미지의 다운로드 URL을 가져옵니다.
  Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);
  String downloadUrl = await storageReference.getDownloadURL();
  return downloadUrl;
}
}
  