import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:totalexam/controllers/user_controller.dart';
import 'package:totalexam/domain/entities/pet.dart';
import 'package:totalexam/presentation/features/pet/controllers/pet_controller.dart';
import 'package:flutter/material.dart';
import 'package:totalexam/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';


class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final UserController _userController = Get.find<UserController>();
  bool _isProfileCardVisible = false;
  Set<String> _expandedPets = {};

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.pacifico()),
      onTap: onTap,
    );
  }

  Widget _buildPetCard(Pet pet) {
    final isExpanded = _expandedPets.contains(pet.id);
    // 접힌 상태
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => _togglePet(pet.id),
            child: Row(
              children: [
                // 사진 or 기본 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                    pet.imageUrl != null
                        ? Image.network(pet.imageUrl!, width: 52, height: 52, fit: BoxFit.cover)
                        : Image.asset('assets/images/부비.png', width: 52, height: 52, fit: BoxFit.cover),
                ),
                // 이름 + 나이
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          pet.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${DateFormat('yyyy.MM.dd').format(pet.birthdate)} · ${pet.age}살',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // 화살표
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
          if (isExpanded) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  _buildDetailRow('생일', '${DateFormat('yyyy.MM.dd').format(pet.birthdate)} · ${pet.age}살'),
                  _buildDetailRow('몸무게', '${pet.weight} kg'),
                  _buildDetailRow('종류', pet.animal == AnimalType.dog ? '강아지' : '고양이'),
                  _buildDetailRow('성별', pet.gender == Gender.male ? '수컷' : '암컷'),
                  _buildDetailRow('중성화', pet.neuter == NeuterStatus.done ? '완료' : '미완료'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('정보 수정'),
                    ),
                  )
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 14)),
        ],
      )
    );
  }

  void _togglePet(String petId) {
    setState(() {
      if (_expandedPets.contains(petId)) {
        _expandedPets.remove(petId);
      } else {
        _expandedPets.add(petId);
      }
    });
  }

  // Widget _buildPetCard(Pet pet) {
  //   return Card(
  //     color: Colors.amber[100],
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       side: const BorderSide(color: Colors.deepPurple, width: 1),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         children: [
  //           pet.imageUrl != null
  //               ? ClipRRect(
  //                 borderRadius: BorderRadius.circular(20.0),
  //                 child: Image.network(
  //                   pet.imageUrl!,
  //                   width: 100,
  //                   height: 100,
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //               : Image.asset(
  //                   "assets/images/부비.png",
  //                   width: 100,
  //                   height: 100,
  //                   fit: BoxFit.cover,
  //                 ),
  //           const SizedBox(width: 20.0),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('이름: ${pet.name}'),
  //                 Text('생일: ${DateFormat('yyyy-MM-dd').format(pet.birthdate)} (${pet.age}세)'),
  //                 Text('몸무게: ${pet.weight} kg'),
  //                 Text('종류: ${pet.animal == AnimalType.dog ? '강아지' : '고양이'}'),
  //                 Text('성별: ${pet.gender == Gender.male ? '수컷' : '암컷'}'),
  //                 Text('중성화: ${pet.neuter == NeuterStatus.done ? '완료' : '미완료'}'),
  //                 if (pet.breed != null) Text('품종: ${pet.breed}'),
  //                 if (pet.registrationNumber != null) Text('등록번호: ${pet.registrationNumber}'),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petProvider);

    return Drawer(
      backgroundColor: mainColor,
      child: Column(
        children: [
          Obx(() => DrawerHeader(
            decoration: BoxDecoration(color: pointColor),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_userController.userProfileImage.value),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      _userController.userName.value,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[850]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userController.userEmail.value,
                      style: TextStyle(fontSize: 16, color: Colors.grey[850]),
                    ),
                  ],
                ),
              ],
            ),
          )),
          _buildListTile(Icons.home, "H O M E", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          }),
          _buildListTile(Icons.person, "P R O F I L E", () {
            setState(() {
              _isProfileCardVisible = !_isProfileCardVisible;
            });
          }),
          if (_isProfileCardVisible)
            Expanded(
              child: petState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : petState.pets.isEmpty
                      ? const Center(child: Text('등록된 반려동물이 없습니다'))
                      : ListView.builder(
                          itemCount: petState.pets.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _buildPetCard(petState.pets[index]),
                                const Divider(height: 1),
                              ],
                            );
                          },
                        ),
            ),
          _buildListTile(Icons.settings, "S E T T I N G S", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/pageC1');
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
