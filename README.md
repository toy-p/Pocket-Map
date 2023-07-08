# KakaoMap 기능 추가

## 1. 현재 위치 검색 기능

<img width="339" alt="스크린샷 2023-07-08 오후 8 19 36" src="https://github.com/toy-p/Pocket-Map/assets/93738662/cd7ae888-36ae-46b8-9588-a5de4ca94e68" style="zoom: 67%;" >

+ 위치 버튼을 추가하여 Floating Button 클릭 시 현재 위치를 찾아서 내 위치로 이동을 하도록 코드 추가
  https://pub.dev/packages/geolocator [현재 위치를 가져올때 사용한 플러그인]

<img width="731" alt="스크린샷 2023-07-08 오후 8 22 32" src="https://github.com/toy-p/Pocket-Map/assets/93738662/cb3718cc-5298-4bf3-8b05-2ccc90c9f98c">

위와 같이 버튼을 클릭시 현재 **위도**와 **경도**를 찾아서 위치를 이동

print를 통해 현재 위치를 debug mode에서 확인 가능



---

## 2. 주소 검색 기능

<img width="335" alt="image" src="https://github.com/toy-p/Pocket-Map/assets/93738662/b0da6e85-c079-439b-9df1-ce2ebc04c69b" style="zoom:67%;" >

+ kpostal 패키지 추가 https://pub.dev/packages/kpostal
+ 도로명 주소를 검색 후 lantitude, longitude 값을 가져와 위치 이동 기능 추가

<img width="733" alt="image" src="https://github.com/toy-p/Pocket-Map/assets/93738662/d6a8bb07-3a7d-44f2-94c0-339a53450582" style="zoom:67%;" >

마찬가지로 검색 된 위도,경도를 print를 통해 확인 할 수 있도록 설정

----

#### 검색기능 문제점 발견 -> 현재 업데이트 완료

<img width="566" alt="image" src="https://github.com/toy-p/Pocket-Map/assets/93738662/5baf84c3-3f68-46b5-9d44-3f8fcd6e037c">


검색 후 다시 지도 화면으로 넘어 간 후에 새로 반영된 위도,경도의 위치로 이동하도록 되어 있는데 delay를 설정하지 않으면 반영이 제대로 되지 않는 문제점을 확인

-> Future 함수를 사용하여 delayed 를 주었지만 각 시뮬레이션 환경에 따라 오차가 있을 수 있으므로 반영이 되지 않는다면 8000 이상의 값을 설정 해 주어야 함.
