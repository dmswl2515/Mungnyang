import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:totalexam/controllers/user_controller.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final UserController _userController = Get.find<UserController>();
  bool _isProfileCardVisible = false;
  List<DocumentSnapshot> _pets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  //Firestore의 'pets' 컬렉션에서 반려동물 정보 가져오기
  Future<void> _fetchPets() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pets').get();
      setState(() {
        _pets = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  //반려동물 생년월일에 따라 현재 나의 계산
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    final birthDate = pet['birthdate'] != null ? (pet['birthdate'] as Timestamp).toDate() : null;
    final age = birthDate != null ? _calculateAge(birthDate) : null;

    return Card(
      color: Colors.amber[100],
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepPurple, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            pet['image'] != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    pet['image'] ?? 'default_image_url',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                : Image.asset(
                    "assets/images/부비.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('이름: ${pet['name'] ?? 'Unknown'}'),
                  Text(
                    '생일: ${birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate) : 'N/A'}'
                    '${age != null ? ' ($age세)' : ''}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('몸무게: ${pet['weight'] ?? 'N/A'} kg'),
                  Text('종류: ${pet['animal'] ?? 'Unknown'}'),
                  Text('성별: ${pet['gender'] ?? 'Unknown'}'),
                  Text('중성화: ${pet['neuter'] ?? 'Unknown'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple[100],
      child: Column(
        children: [
          Obx(() => DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple[200],
            ),
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
                    const SizedBox(height: 40,),
                    Text(
                      _userController.userName.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[850],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userController.userEmail.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[850],
                      ),
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
              child: _pets.isEmpty
                  ? Center(child: Text("No pets found"))
                  : ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, index) {
                        final pet = _pets[index].data() as Map<String, dynamic>;
                        return _buildPetCard(pet);
                      },
                    ),
            ),
          _buildListTile(Icons.settings, "S E T T I N G S", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/pageC1');
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
