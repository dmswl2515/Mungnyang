import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:totalexam/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totalexam/domain/entities/pet.dart';
import 'package:totalexam/domain/entities/pet_create_form.dart';
import 'package:totalexam/data/repositories/mock/mock_breed_data.dart';

class PetRegistrationsScreen extends ConsumerStatefulWidget {
  const PetRegistrationsScreen({super.key});

  @override
  ConsumerState<PetRegistrationsScreen> createState() => _PetRegistrationScreenState();
}

class _PetRegistrationScreenState extends ConsumerState<PetRegistrationsScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final int _totalSteps = 7;
  int _currentStep = 0;
  String _breedSearch = '';
  DateTime? _selectedDate;

  // 입력 데이터 보관용
  final PetCreateForm _form = PetCreateForm();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < _totalSteps -1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  void _submitForm() {//TODO: 등록 로직
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        leading: _currentStep > 0
          ? IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _prevPage,
            )
          : null,
      ),
      body: Column(
        children: [
          // 상단 진행 표시(발바닥 아이콘)
          _buildProgressIndicator(),

          // 페이지 내용
          Expanded(
            child: PageView (
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),  // 동물 선택
                _buildStep2(),  // 품종 선택
                _buildStep3(),  // 이름 선택
                _buildStep4(),  // 생년월일 선택
                _buildStep5(),  // 성별 선택
                _buildStep6(),  // 몸무게 선택
                _buildStep7(),  // 등록 확인
              ],
            ),
          ),
          // 다음 버튼
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.pets,
              size: index <= _currentStep ? 23: 16,
              color: index <= _currentStep ? pointColor : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader({required String title, required String subtitle}) {
    return Column(
      children: [
        Image.asset('assets/images/부비.png', width: 70, height: 70),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: greyColor)),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildNextButton() {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 2, 24, 14),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLastStep ? _submitForm : _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: pointColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(isLastStep ? '등록' : '다음',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: greyColor, fontSize: 14, fontWeight: FontWeight.bold)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPetCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  '${_form.breed} 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            ),
            const Divider(),

            _buildDetailsRow('품종', _form.breed ?? '-'),
            _buildDetailsRow('이름', _form.name ?? '-'),
            _buildDetailsRow('생일', _form.birthdate != null
              ? '${_form.birthdate!.year}.${_form.birthdate!.month}.${_form.birthdate!.day}'
              : '-'),
            _buildDetailsRow('성별', _form.gender == Gender.male ? '수컷' : '암컷'),
            _buildDetailsRow('중성화', _form.neuter == NeuterStatus.done ? '완료' : '미완료'),
            _buildDetailsRow('몸무게', _form.weight != null ? '${_form.weight} kg' : '-'),
          ],
        ),
      ),
    );
  }

  // 각 단계 - 일반 placeholder
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
              title: '어떤 친구인가요?',
              subtitle: '함께하는 반려동물을 골라주세요',
          ),

          // 강아지 카드
          GestureDetector(
            onTap: () {
              setState(() => _form.animal = AnimalType.dog);
              _nextPage();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              //선택 됐으면 테두리 강조
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _form.animal == AnimalType.dog ? pointColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Text('🐶', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 16),
                  const Text('강아지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Text('멍멍', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          // 고양이 카드 (동일 구조)
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() => _form.animal = AnimalType.cat);
              _nextPage();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              // 선택 됐으면 테두리 강조
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _form.animal == AnimalType.cat ? pointColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Text('🐱', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 16),
                  const Text('고양이', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Text('야옹', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  } // 반려동물 종류
  Widget _buildStep2() {
    // 품종 데이터 보관용
    final breeds = (_form.animal == AnimalType.dog ? dogBreeds : catBreeds)
      .where((b) => b.contains(_breedSearch))
      .toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
              title: '품종을 알려주세요',
              subtitle: '검색하거나 직접 입력할 수 있어요',
          ),

          // 검색창
          TextField(
            onChanged: (value) => setState(() => _breedSearch = value),
            decoration: InputDecoration(
              hintText: '품종 검색',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(Icons.search),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height:12),
          Expanded(
            child: ListView.separated(
              itemCount: breeds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final breed = breeds[index];
                final isSelected = _form.breed == breed;

                return GestureDetector(
                  onTap: () {
                    setState(() => _form.breed = breed);
                    _nextPage();
                  },
                    child: Container(
                    padding: const EdgeInsets.all(16),

                    // 선택 시 테두리 강조
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? pointColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(breed, style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } // 품종
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
            title: '이름이 뭐예요?',
            subtitle: '평소 부르는 애칭도 좋아요',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextFormField(
              controller: _nameController,
              onChanged: (value) => _form.name = value,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '이름 입력',
                hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal:20, vertical: 20),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: pointColor, width:2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: pointColor, width:2),
                ),
              ),
            ),
          )
        ],
      ),
    );
  } // 이름
  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
              title: '생일은 언제예요?',
              subtitle: '대략적인 날짜도 괜찮아요'
          ),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  _form.birthdate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: pointColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, color: pointColor),
                  const SizedBox(width: 12),
                  Text(_selectedDate == null
                    ? '날짜를 선택해주세요'
                    : '${_selectedDate!.year}.${_selectedDate!.month}.${_selectedDate!.day}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ]
      )
    );
  } // 생일
  Widget _buildStep5() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
              title: '성별을 선택해주세요',
              subtitle: '중성화 여부도 알려주세요'
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => setState(() => _form.gender = Gender.male),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _form.gender == Gender.male ? pointColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.mars, size: 28, color: pointColor),
                    const SizedBox(width: 25),
                    const Text('수컷', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => setState(() => _form.gender = Gender.female),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _form.gender == Gender.female ? pointColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.venus, size: 28, color: pointColor),
                    const SizedBox(width: 25),
                    const Text('암컷', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 25),
                  const Text('중성화 여부', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: pointColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _form.neuter = NeuterStatus.done),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: _form.neuter == NeuterStatus.done ? subColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: pointColor),
                            ),
                            child: Text('완료',
                              style: TextStyle(
                                color: _form.neuter == NeuterStatus.done ? Colors.white : Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => setState(() => _form.neuter = NeuterStatus.yet),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _form.neuter == NeuterStatus.yet ? subColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: pointColor),
                            ),
                            child: Text('미완료',
                              style: TextStyle(
                                color: _form.neuter == NeuterStatus.yet ? Colors.white : Colors.black45,
                                 fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } // 성별 및 중성화 여부
  Widget _buildStep6() {
     return Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
         children: [
           _buildStepHeader(
               title: '몸무게를 입력해주세요',
               subtitle: '건강그래프로 몸무게를 관리해요.'
           ),
           Padding(
             padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
             child: TextField(
               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
               controller: _weightController,
               keyboardType: const TextInputType.numberWithOptions(decimal: true),
               onChanged: (value) => _form.weight = double.tryParse(value),
               textAlign: TextAlign.center,
               decoration: InputDecoration(
                 suffixText: 'kg',
                 hintText: "0.0",
                 hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                 contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                 filled: true,
                 fillColor: Colors.white,
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(30),
                   borderSide: const BorderSide(color: pointColor, width: 2),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(30),
                   borderSide: const BorderSide(color: pointColor, width: 2),
                 )
               ),
             ),
           )
         ],
       ),
     );
  } // 몸무게
  Widget _buildStep7() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader(
              title: '${_form.name ?? '친구'} 등록 완료',
              subtitle: '이제부터 ${_form.name ?? '친구'}의 하루를 기록해요.'
          ),
          _buildPetCard()
        ],
      ),
    );
  }

}

