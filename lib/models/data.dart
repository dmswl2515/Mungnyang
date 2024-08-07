
import 'package:flutter/material.dart';
import '../reference/constants.dart';

class Data {
  final String title;
  final Icon icon1,
             icon2,
             icon3,
             icon4,
             icon5,
             icon6,
             icon7;
             

  Data({
    required this.title,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.icon4,
    required this.icon5,
    required this.icon6,
    required this.icon7,
  });
}

List<Data> demoData = [
  Data(
    title: "식사/간식",
    icon1: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,), 
    icon2: Icon(Icons.clear, size: 18, color: Colors.white54,), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
    icon5: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon6: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon7: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
  ),
  Data(
    title: "배뇨", 
    icon1: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,), 
    icon2: Icon(Icons.clear, size: 18, color: Colors.white54,), 
    icon3: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,),   
    icon4: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,),  
    icon5: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon6: Icon(Icons.clear, size: 18, color: Colors.white54,),    
    icon7: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,),  
  
  ),
  Data(
    title: "놀이", 
    icon1: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,), 
    icon2: Icon(Icons.clear, size: 18, color: Color(0xFF01DFFF),), 
    icon3: Icon(Icons.clear, size: 18, color: Color(0xFF01DFFF),),  
    icon4: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor2,),  
    icon5: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon6: Icon(Icons.clear, size: 18, color: Colors.white54,),    
    icon7: Icon(Icons.clear, size: 18, color: Color(0xFF01DFFF),),  
  ),
  Data(
    title: "산책", 
    icon1: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),),
    icon2: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),),  
    icon5: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon6: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),),    
    icon7: Icon(Icons.clear, size: 18, color: Colors.white54,),    
  ),
  Data(
    title: "양치/목욕", 
    icon1: Icon(Icons.clear, size: 18, color: Color(0xFFF9A266),),
    icon2: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.clear, size: 18, color: Colors.white54,),  
    icon5: Icon(Icons.clear, size: 18, color: Color(0xFFF9A266),),  
    icon6: Icon(Icons.clear, size: 18, color: Color(0xFFF9A266),),    
    icon7: Icon(Icons.clear, size: 18, color: Colors.white54,),    
  ),
  Data(
    title: "미용", 
    icon1: Icon(Icons.clear, size: 18, color: Colors.white54,), 
    icon2: Icon(Icons.clear, size: 18, color: Color(0xFF4FF0B4),), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.clear, size: 18, color: Colors.white54,),  
    icon5: Icon(Icons.clear, size: 18, color: Color(0xFFF9A266),),  
    icon6: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon7: Icon(Icons.clear, size: 18, color: Colors.white54,),    
  ),
  Data(
    title: "병원",
    icon1: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,), 
    icon2: Icon(Icons.clear, size: 18, color: Colors.white54,), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
    icon5: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon6: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon7: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
  ),
  Data(
    title: "약",
    icon1: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,), 
    icon2: Icon(Icons.clear, size: 18, color: Colors.white54,), 
    icon3: Icon(Icons.clear, size: 18, color: Colors.white54,),   
    icon4: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
    icon5: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon6: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),   
    icon7: Icon(Icons.check_circle_sharp, size: 18, color: secondaryColor,),  
  ),
];

