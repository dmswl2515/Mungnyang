# 멍냥멍냥(MungNyang)
[1. 개요](#1개요)<br>
[2. 사용언어 및 개발환경](#2-사용언어-및-개발환경)<br>
[3. 기능 소개](#3-기능-소개)<br>
[4. TROUBLESHOOTING](#4-troubleshooting)<br>
[5. 느낀점](#5-느낀점)


## 1.개요
| `목록`            | `내용`                                                                                                                           |
|     :---:         | -------------------------------------------------------------------------------------------------------------------------------- |
| `작업기간`         | `2주`                                                                                                                            |
| `참여인원`         | `개인`                                                                                                                           |
| `프로젝트 목적`    | `편리하게 반려동물의 건강과 활동을 관리하고, 여가 및 스트레스를 효과적으로 지원하기 위한 플랫폼입니다.`                                  |
| `주요업무`         | `- 반려동물 등록 및 건강 관리 기능 구현` <br> `- SNS 로그인 및 AI 채팅 기능을 위한 API 연동` <br> `- 터치 스크린 기반 간단한 게임 구현`  |


## 2. 사용언어 및 개발환경
- Dart, Firebase, Flutter, Github



## 3. 기능 소개

#### 로그인
<img src="https://github.com/user-attachments/assets/b46f0e8e-9aea-4482-a6d7-253fe8c58728" width="450" height="300"/>

#### SNS 로그인
<img src="https://github.com/user-attachments/assets/c36cf5e4-d11d-4e8c-b48e-afd09c56aa3d" width="450" height="300"/>
<img src="https://github.com/user-attachments/assets/85590a7b-abab-4e9e-840d-2bef264e12e9" width="450" height="300"/>

#### 다크모드 & 화이트모드
<img src="https://github.com/user-attachments/assets/27eda8e1-3121-40e9-943c-e509ad26fafc" width="200" height="300"/>
<img src="https://github.com/user-attachments/assets/95466ee0-7546-4388-897c-6800d9255c29" width="450" height="300"/>

#### 반려동물 정보입력
<img src="https://github.com/user-attachments/assets/34892794-416d-4932-9ebf-25765b0ad8b2" width="450" height="300"/>

#### 반려동물 정보 불러오기
<img src="https://github.com/user-attachments/assets/0c0759cb-b4cd-4b99-981b-81d4579d1605" width="200" height="300"/>
<img src="https://github.com/user-attachments/assets/41bdf76c-f93c-413b-ab39-d86c3cc90530" width="450" height="300"/>

#### 행동 관리
<img src="https://github.com/user-attachments/assets/1201c3fd-70fe-482d-a542-1115e4770bb1" width="200" height="300"/>
<img src="https://github.com/user-attachments/assets/dcfd8913-2fcf-42a0-aede-35ba2596d0eb" width="450" height="300"/>

#### 일정 관리
<img src="https://github.com/user-attachments/assets/08c8ee3e-a4e0-44d6-8c95-e7e00981305d" width="450" height="300"/>

#### 주간 보고서
<img src="https://github.com/user-attachments/assets/bca81bae-b504-4ce4-941a-75171534bfc8" width="200" height="300"/>
<img src="https://github.com/user-attachments/assets/fac178da-7043-4d4d-ad68-dbd8c942e5df" width="450" height="300"/>

#### 일기장
<img src="https://github.com/user-attachments/assets/31dcd738-2036-45d9-bb38-854fdc2e8652" width="450" height="300"/>

#### Ai 채팅
<img src="https://github.com/user-attachments/assets/cd38b92f-42fb-41b2-85ae-ef7f65470fa8" width="200" height="300"/>
<img src="https://github.com/user-attachments/assets/731ec129-f122-47cb-acd4-0addd04480c7" width="450" height="300"/>

#### 호흡수 체크
<img src="https://github.com/user-attachments/assets/2e650631-df7b-463d-a063-b5e1f4c43189" width="450" height="300"/>
<img src="https://github.com/user-attachments/assets/66c48fa5-74f7-42f2-ad5f-dc07f0ca9609" width="450" height="300"/>
<img src="https://github.com/user-attachments/assets/93d91eac-9d9c-4be5-be84-e974b65c0865" width="450" height="300"/>
<img src="https://github.com/user-attachments/assets/f0ab3995-56b2-4a3b-b9f7-93634fcc1186" width="450" height="300"/>

#### 미니 게임
<img src="https://github.com/user-attachments/assets/b2b444ed-1d78-4898-a902-094b4f17d302" width="450" height="300"/>
<img src="https://github.com/user-attachments/assets/1e43ff80-950b-48c7-a19d-262a7528296d" width="200" height="300"/>



## 4. TROUBLESHOOTING
- Firestore에서 or 조건 처리<br>
  `petName`을 기준으로 활동 내역을 조회할 때, `selectedPetName`과 `all_pets` 데이터를 함께 가져오려고 했으나,<br>
  `or` 연산자를 지원하지 않아 두 개의 쿼리를 작성해 결과를 수동으로 병합해야 했습니다.<br>
  그러나 이러한 방식은 코드가 길어져 유지보수가 어려웠고, 두 번 요청을 보내는 구조라 성능 면에서도 비효율적이었습니다.<br>
  이를 해결하기 위해 `whereIn` 연산자를 사용하였고 `petNamesToFetch` 리스트의 조건을 한 번에 조회하여 코드의 간결성과 성능을 개선할 수 있었습니다.

- onTap 미작동 문제 해결<br>
  `CurvedNavigationBar`와 터치 이벤트가 발생하는 버튼이 같은 화면에 배치되면서 `onTap` 이벤트가 제대로 작동하지 않는 문제가 발생했습니다.<br>
  문제가 발생하는 버튼들을 `Transform.rotate`로 감싸서 각도를 조정하고, `Positioned`위젯을 사용해 정확한 위치에 배치했습니다.<br>
  이를 통해 터치 이벤트를 정상적으로 받을 수 있도록 UI가 재정렬되었습니다.  


  ## 5. 느낀점
  프로젝트를 통해 효율적인 데이터 처리와 최적화의 중요성을 다시 한번 실감했습니다.<br>
  불필요한 요청을 줄이고 코드의 간결성을 높이는 것이 유지보수뿐만 아니라 시스템 성능에도 큰 영향을 미친다는 점을 깊이 체감했습니다.
