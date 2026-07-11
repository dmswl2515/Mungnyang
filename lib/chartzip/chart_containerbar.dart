import 'package:totalexam/reference/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerBar extends StatelessWidget {
  const ContainerBar({
    super.key, 
    required this.title, 
    required this.value, 
    required this.percentage, 
    required this.color,
  });
  
  final String title, value;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: 
    Container(
      child: Column(children: [
        Row(children: [
          Text(
            title,
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400),
          ),
          Spacer(),
            Text(
              value,
              style: GoogleFonts.ubuntu(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w600),
            ),
        ],),
        SizedBox(height: 5,),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 7,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],),
    ));
  }
}