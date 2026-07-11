import 'package:flutter/material.dart';
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
  int _currentStep = 0;
  final int _totalSteps = 7;

  // 입력 데이터 보관용
  final PetCreateForm _form = PetCreateForm();

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

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: pointColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            '다음',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
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
          Image.asset(
            'assets/images/부비.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          // 제목
          Text('어떤 친구인가요?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('함께하는 반려동물을 골라주세요', style: TextStyle(color: Colors.black45)),
          SizedBox(height: 28),

          // 강아지 카드
          GestureDetector(
            onTap: () => setState(() => _form.animal = AnimalType.dog),
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
            onTap: () => setState(() => _form.animal = AnimalType.cat),
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
  }
  Widget _buildStep2() {
    // 품종 데이터 보관용
    final breeds = _form.animal == AnimalType.dog ? dogBreeds : catBreeds;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Image.asset(
            'assets/images/부비.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          // 제목
          Text('품종을 알려주세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('검색하거나 직접 입력할 수 있어요', style: TextStyle(color: Colors.black45)),

          SizedBox(height: 28),

          // 검색창
          Expanded(
            child: ListView.separated(
              itemCount: breeds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final breed = breeds[index];
                final isSelected = _form.breed == breed;

                return GestureDetector(
                  onTap: () => setState(() => _form.breed = breed),
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
  }
  Widget _buildStep3() => const Center(child: Text('Step 3: 이름'));
  Widget _buildStep4() => const Center(child: Text('Step 4: 생년월일'));
  Widget _buildStep5() => const Center(child: Text('Step 5: 성별/중성화'));
  Widget _buildStep6() => const Center(child: Text('Step 6: 몸무게'));
  Widget _buildStep7() => const Center(child: Text('Step 7: 등록'));

}

