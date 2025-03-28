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

  //selectd image index
  int? _currentSelectedIndex;

  //클릭한 이미지의 정보를 저장하는 리스트
  List<Map<String, dynamic>> allClickedImages = [];   //전체 데이터
  List<Map<String, dynamic>> clickedImages = [];      //선택된 날짜의 데이터

  //캘린더
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //캘린더의 마크표시
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DateTime> fetchedDates = [];

  //선택된 반려동물의 이름을 기본값으로 설정
  String selectedPetName = "all_pets";  
  List<String> petNamesToFetch = ['all_pets'];
  // 선택된 반려동물의 이미지를 저장할 변수
  String? selectedPetImage;

  @override
  void initState() {
    super.initState();
    _fetchFromFirestore(petNamesToFetch);  //활동 데이터 가져오기
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
          ProfileButton(context),
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
            onDaySelected: _onDaySelected, //날짜를 선택했을 때 호출되는 함수
            onFormatChanged: (format) {    //캘린더 형식이 변할 때 호출되는 함수
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final localDate = DateTime(date.year, date.month, date.day);
                print('localDate : $localDate');
                print('fetchedDates : $fetchedDates');

                if(fetchedDates.contains(localDate)) {
                  return Align(
                    alignment:Alignment.bottomCenter,
                    child: Container( //마커
                      margin: const EdgeInsets.only(top: 30),
                      width: 30,
                      height: 30,
                      child : const Icon(
                              Icons.pets,
                              color : Colors.black54,
                              size: 13,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
                int clickedIndex = clickedImages[index]['index'];
                String timeWithParentheses = '(${clickedImages[index]['startTime']})'; // 시간에 괄호 추가
                
                return buttonSlider(index, clickedIndex, timeWithParentheses); 
              },
            ),
          ),
        ],
      ),
    );
  }

  IconButton ProfileButton(BuildContext context) {
    return IconButton(
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
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '반려동물 선택',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('케어할 반려동물을 선택해주세요'),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 한 줄에 3개의 항목을 배치
                            crossAxisSpacing: 10.0, // 아이템 사이의 가로 간격
                            mainAxisSpacing: 10.0, // 아이템 사이의 세로 간격
                            childAspectRatio: 1, // 아이템의 가로세로 비율
                          ),
                          itemCount: snapshot.data!.docs.length + 1,
                          itemBuilder: (context, index) {
                            if(index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPetName = 'all_pets';
                                    petNamesToFetch = ['all_pets'];
                                    selectedPetImage = null;
                                  });
                                  Navigator.pop(context); // 모달 닫기
                                  _fetchFromFirestore(petNamesToFetch);
                                },
                                child: const Column(
                                  children: [
                                    // 모달창에서 기본 이미지
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/images/부비.png'), // 기본 이미지
                                      radius: 30, // 프로필 이미지 크기
                                    ),
                                    SizedBox(height: 5),
                                    Text('전체', style: TextStyle(fontSize: 16)),  // "전체" 텍스트
                                  ],
                                ),
                              );
                            } else {
                              var doc = snapshot.data!.docs[index - 1];
                              return GestureDetector(
                                onTap: () {
                                  String petName = doc['name'];

                                  // 반려동물 선택 시 selectedPetName을 갱신하고 petNamesToFetch에 반영
                                  setState(() {
                                    selectedPetName = petName;   //선택된 반려동물의 이름을 저장 
                                    petNamesToFetch = ['all_pets', petName];
                                    selectedPetImage = doc['image']; //선택된 반려동물 이미지 저장
                                  });
                                  Navigator.pop(context);  // 선택 후 모달 닫기
                                  
                                  // 선택된 반려동물의 활동 데이터를 다시 불러오기
                                  _fetchFromFirestore(petNamesToFetch);
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(doc['image']),
                                      radius: 30, // 프로필 이미지 크기
                                    ),
                                    const SizedBox(height: 5),
                                    Text(doc['name']),
                                  ],
                                ),
                              );
                            }
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
                            child: const Text('취소'),
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
        backgroundImage: selectedPetImage != null
          ? NetworkImage(selectedPetImage!)
          : const AssetImage('assets/images/부비.png'), 
        radius: 20,
      ),
    );
  }

  //버튼을 누르면 page1에 인덱스 전달
  void _updateTextProvider(int index) {
    _currentSelectedIndex = index;
    print('_currentSelectdIndex: $_currentSelectedIndex');
    Provider.of<TextProvider>(context, listen: false).updateIndex(index);
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

  //반려동물 활동 전체 데이터 가져오기
  Future<void> _fetchFromFirestore(List<String> petNamesToFetch) async {
  try {
    //pet_activites 컬렉션에서 데이터를 가져오기 위해 query 객체 생성
    Query query = FirebaseFirestore.instance.collection('pet_activities');

    // selectedPetName이 null이 아니고 'all_pets'가 아니면 해당 이름도 추가
    if (selectedPetName != null && selectedPetName != 'all_pets') {
      petNamesToFetch.add(selectedPetName);
    }
    
    //'petName' 필드가 petNamesToFetch 리스트에 포함된 값들인 데이터를 가져오기
    final snapshot = await query.where('petName', whereIn: petNamesToFetch).get();

    //활동 데이터의 모든 정보 추출
    final List<Map<String, dynamic>> loadedData = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('data from firebase where petName: $data');

      //'date' 필드를 DateTime 형식으로 변환 (Timestamp일 경우만 변환)
      final date = data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(); // date가 null일 경우 기본값으로 현재 시간 사용

      return {
        'id': doc.id,
        'index': imageNames.indexOf(data['category']),
        'date': data['date'],  
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

    //활동 데이터의 날짜만 추출
    fetchedDates = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;

        print('펫이름에 따른 date : $data');

        if (data != null && data.containsKey('date')) {
          return DateTime.parse(doc['date'] as String);
        } else {
          return null;
        }
      }).where((date) => date != null).map((date) => date as DateTime).toList();

      print('fetchedDates: $fetchedDates');
  } catch (e) {
    print('Error fetching data from Firestore: $e');
  }
}

  //날짜 선택 시 호출되는 함수
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

  //선택한 날짜에 해당하는 이미지만 필터링하는 함수
  void _filterImagesByDate(DateTime date) {
  print('Filtering images for date: $date and petName: $petNamesToFetch');
  print('All clicked images before filtering: $allClickedImages');

  setState(() {
    clickedImages = allClickedImages.where((image) {
      final imageDate = DateTime.parse(image['date']); // 문자열을 DateTime으로 변환
      final bool isSameDate = imageDate.year == date.year &&
                              imageDate.month == date.month &&
                              imageDate.day == date.day;

      // selectedPetName이 'all_pets'일 경우 모든 데이터 표시
      if (petNamesToFetch.contains('all_pets')) {
        return isSameDate;  
      } else {
        return petNamesToFetch.contains(image['petName']);  // 선택된 petName과 일치하는 데이터만 표시
      }
    }).toList();
    print('Clicked images filtered: $clickedImages'); // 필터링된 데이터 확인
  });
}


  //활동 추가 함수
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
    _fetchFromFirestore(petNamesToFetch); // Firestore에서 데이터를 다시 가져옴
  } catch (e) {
    print('Error saving activity to Firestore: $e');
  }
}

  //항목 삭제 함수
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

  //페이지 수정 함수
  Future<void> _navigateToPage(int clickedIndex, int index) async {
  var data = {
    'id': clickedImages[index]['id'],
    'title': clickedImages[index]['title'],
    'memo': clickedImages[index]['memo'],
    'startTime': clickedImages[index]['startTime'] ?? '09:00',
    'endTime': clickedImages[index]['endTime'] ?? '21:30',
    'date': (clickedImages[index]['date'] is DateTime)
            ? clickedImages[index]['date']
            : DateTime.parse(clickedImages[index]['date']),
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
        initialDate: data['date'],
      ),
    ),
  );

  print('Result from EditPage: $result'); // 반환값 확인

  if (result == true) {
    print("Fetching data from Firestore...");
    await _fetchFromFirestore(petNamesToFetch); // Firestore에서 데이터를 다시 가져옴
  }
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
                    initialDate: (clickedImages[index]['date'] is DateTime)
                        ? clickedImages[index]['date']
                        : DateTime.parse(clickedImages[index]['date']),
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
        const SizedBox(width: 5,),
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
}
  