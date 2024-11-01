# 멍냥멍냥(MungNyang)
[1. 개요](#1개요)<br>
[2. 사용언어 및 개발환경](#2-사용언어-및-개발환경)<br>
[3. 기능 소개](#3-기능-소개)<br>
[4. TROUBLESHOOTING](#4-troubleshooting)<br>
[5. 느낀점](#5-느낀점)


## 1.개요
| `목록`            | `내용`                                                                                                       |
|     :---:      | ------------------------------------------------------------------------------------------------------------- |
| `작업기간`    | `2024.07.19 - 2024.08.01(2주)`                                                                                    |
| `기여도`     | `개인(100%)`                                                                                                       |
| `프로젝트 목적` | `편리하게 반려동물의 건강과 활동을 관리하고, 여가 및 스트레스를 효과적으로 지원하기 위한 플랫폼입니다.`                                  |
| `주요업무`     | `- 반려동물 등록 및 건강 관리 기능 구현` <br> `- SNS 로그인 및 AI 채팅 기능을 위한 API 연동` <br> `- 터치 스크린 기반 간단한 게임 구현` |


## 2. 사용언어 및 개발환경
| `목록`            | `기술스택`                                                                              |
|     :---:      | ----------------------------------------------------------------------------------------|
| `OS`    | `Windows10` `Mac Os`                                                                           |
| `Language`     | `Dart`                                                                                  |
| `DataBase` | `Firebase` `Firestore Database` `sqflite`                                                   |
| `Develop Tool` | `Flutter` `VSCode` `Android Studio(Emulator)`                                           |
| `API` | `Naver API` `Gemini API` `Firebase Authentication`                                               |
| `Library` | `pub.dev` `Provider` `Image Picker` `GetWidget` `Table Calendar` `Syncfusion Flutter Charts` |
| `Version control`    | `GitHub` `SourceTree`                                                             |


## 3. 기능 소개


## 4. TROUBLESHOOTING
- onTap 미작동 문제 해결<br>
  `CurvedNavigationBar`와 터치 이벤트가 발생하는 버튼이 같은 화면에 배치되면서 `onTap` 이벤트가 제대로 작동하지 않는 문제가 발생했습니다.<br>
  문제가 발생하는 버튼들을 `Transform.rotate`로 감싸서 각도를 조정하고, `Positioned`위젯을 사용해 정확한 위치에 배치했습니다.<br>
  이를 통해 터치 이벤트를 정상적으로 받을 수 있도록 UI가 재정렬되었습니다.  

- SpeedDial overlay 문제<br>
  `SpeedDial`기능 사용 시, overlay가 다른 페이지로 전환되거나 화면을 클릭해도 닫히지 않아 클릭 이벤트를 차단하는 문제가 발생했습니다.<br>
  `closeManually: false`로 설정하여 메인 버튼뿐만 아니라 화면을 클릭해도 overlay가 자동으로 닫히도록 구현했습니다.<br>
  이를 통해 플로팅 버튼 인터랙션을 개선하고 사용자 편의성을 높일 수 있었습니다.


  ## 5. 느낀점
  Flutter UI 구현 시 발생할 수 있는 다양한 문제를 해결하는 역량을 키웠고, 사용자 경험의 안정성을 제공하는 방법에 대해 깊게 이해할 수 있었습니다. 
