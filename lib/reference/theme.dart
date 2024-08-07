import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClur = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClur;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);


class Themes {

  static final light = ThemeData (
    dialogBackgroundColor : Colors.white,
    primaryColor : primaryClr,
    brightness : Brightness.light
  );

  static final dark = ThemeData (
    dialogBackgroundColor: darkGreyClr,
    primaryColor : darkGreyClr,
    brightness : Brightness.dark
  );
}

//텍스트에 계속 호출할 수 있음
TextStyle get subHeadingStyle {
  return GoogleFonts.lato (
    textStyle : TextStyle (
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
    )
  );
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato (
    textStyle : TextStyle (
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black
    )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato (
    textStyle : TextStyle (
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.white:Colors.black
    )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato (
    textStyle : TextStyle (
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600],
    )
  );
}

//   var selectedColor = 0.obs; // 색상 상태를 관리하는 RxInt
//   void updateSelectedColor(int colorIndex) {
//     selectedColor.value = colorIndex; // 색상 업데이트
//   }
// }