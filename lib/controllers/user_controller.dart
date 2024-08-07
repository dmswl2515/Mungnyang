import 'package:get/get.dart';

class UserController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userProfileImage = ''.obs;

  void setUser(String name, String email, String profileImage) {
    userName.value = name;
    userEmail.value = email;
    userProfileImage.value = profileImage;
  }

   void setUserProfileImage(String profileImage) {
    userProfileImage.value = profileImage;
  }
}


