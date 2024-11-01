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

#### 로그인
<img src="https://github.com/user-attachments/assets/b46f0e8e-9aea-4482-a6d7-253fe8c58728" width="400" height="250"/>

#### SNS 로그인
<img src="https://github.com/user-attachments/assets/c36cf5e4-d11d-4e8c-b48e-afd09c56aa3d" width="400" height="250"/>

#### Naver 사용자 정보 활용
<img src="https://github.com/user-attachments/assets/85590a7b-abab-4e9e-840d-2bef264e12e9" width="400" height="250"/>

#### 다크모드 & 화이트모드
<img src="https://github.com/user-attachments/assets/c1f71eac-109a-492d-b4d2-0bd4ca71a72d" width="400" height="250"/>

#### 반려동물 정보입력
<img src="https://github.com/user-attachments/assets/34892794-416d-4932-9ebf-25765b0ad8b2" width="400" height="250"/>

#### 반려동물 정보 불러오기
<img src="https://github.com/user-attachments/assets/41bdf76c-f93c-413b-ab39-d86c3cc90530" width="400" height="250"/>

#### 행동 관리
<img src="https://github.com/user-attachments/assets/dcfd8913-2fcf-42a0-aede-35ba2596d0eb" width="400" height="250"/>

#### 일정 관리
<img src="https://github.com/user-attachments/assets/08c8ee3e-a4e0-44d6-8c95-e7e00981305d" width="400" height="250"/>

#### 주간 보고서
<img src="https://github.com/user-attachments/assets/fac178da-7043-4d4d-ad68-dbd8c942e5df" width="400" height="250"/>

#### 일기장
<img src="https://github.com/user-attachments/assets/31dcd738-2036-45d9-bb38-854fdc2e8652" width="400" height="250"/>

#### Ai 채팅
<img src="https://github.com/user-attachments/assets/d63d7819-6fb9-4ad2-b9b1-d1accfa525a0" width="400" height="250"/>

#### 호흡수 체크
<img src="https://github.com/user-attachments/assets/66c48fa5-74f7-42f2-ad5f-dc07f0ca9609" width="400" height="250"/>
<img src="https://github.com/user-attachments/assets/93d91eac-9d9c-4be5-be84-e974b65c0865" width="400" height="250"/>
<img src="https://github.com/user-attachments/assets/f0ab3995-56b2-4a3b-b9f7-93634fcc1186" width="400" height="250"/>

#### 미니 게임
<img src="https://github.com/user-attachments/assets/b2b444ed-1d78-4898-a902-094b4f17d302" width="400" height="250"/>


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
