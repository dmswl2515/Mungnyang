import 'package:flutter/material.dart';
import 'package:totalexam/reference/theme.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top : 16 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //제목 맨 왼쪽에 위치하게 하기
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top:8.0),
            padding: EdgeInsets.only(left: 14),   //Hint position adjustment
            decoration: BoxDecoration(  
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700], //다크모드일 때 밝은회색 아니면 어두운 회색
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(
                          color: context.theme.dialogBackgroundColor,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder( 
                        borderSide: BorderSide(
                          color: context.theme.scaffoldBackgroundColor,
                          width: 0,
                        )
                      )
                    ),  
                  ),
                ),
                widget == null?Container():Container(child:widget)
              ],
            ),
          )
        ],
      ),
    );
  }
}