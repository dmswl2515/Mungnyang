import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileButton extends StatelessWidget {
  final String? selectedPetImage;
  final void Function(String petName, String? petImage) onPetSelected;
  final bool includeAllPetsOption;

  const ProfileButton({
    Key? key,
    this.selectedPetImage,
    required this.onPetSelected,
    this.includeAllPetsOption = true,
  }) : super(key: key);

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.deepPurple[200],
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('pets').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('반려동물 정보가 없습니다.'));
            }

            return Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('반려동물 선택', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('케어할 반려동물을 선택해주세요'),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: snapshot.data!.docs.length + (includeAllPetsOption ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (includeAllPetsOption && index == 0) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onPetSelected('all_pets', null);
                            },
                            child: const Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/부비.png'),
                                  radius: 30,
                                ),
                                SizedBox(height: 5),
                                Text('전체', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          );
                        } else {
                          final doc = snapshot.data!.docs[index - (includeAllPetsOption ? 1 : 0)];
                          final petName = doc['name'];
                          final petImage = doc['image'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onPetSelected(petName, petImage);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(petImage),
                                  radius: 30,
                                ),
                                const SizedBox(height: 5),
                                Text(petName),
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showModal(context),
      icon: CircleAvatar(
        backgroundImage: selectedPetImage != null
            ? NetworkImage(selectedPetImage!)
            : const AssetImage('assets/images/부비.png') as ImageProvider,
        radius: 20,
      ),
    );
  }
}
