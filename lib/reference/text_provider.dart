import 'package:flutter/material.dart';

class TextProvider with ChangeNotifier {
  String _currentText = '';

  String get currentText => _currentText;

  void updateIndex(int index) {
    // 인덱스에 따라 텍스트를 업데이트하는 로직
    switch (index) {
      case 0:
        _currentText = '방금 식사를 했어요';
        break;
      case 1:
        _currentText = '방금 배변을 봤어요';
        break;
      case 2:
        _currentText = '방금 놀이를 했어요';
        break;
      case 3:
        _currentText = '방금 산책을 했어요';
        break;
      case 4:
        _currentText = '방금 양치/목욕을 했어요';
        break;
      case 5:
        _currentText = '방금 미용하고 왔어요';
        break;
      case 6:
        _currentText = '방금 병원다녀왔어요';
        break;
      case 7:
        _currentText = '방금 호흡수를 쟀어요';
        break;
      case 8:
        _currentText = '방금 심박수를 쟀어요';
        break;
      // 추가 인덱스 및 텍스트 업데이트 로직
      default:
        _currentText = '알 수 없는 항목';
        break;
    }
    notifyListeners();
  }
}
