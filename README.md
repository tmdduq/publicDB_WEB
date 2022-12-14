기존에 Java언어는 어느정도 다뤄봤는데
WEB개발은 한 번도 해본 적 없는 영역이였습니다.
 
 S/W 실무교육을 통해 Javascript의 기본을 배웠고
 이를 토대로 안전한 대한민국을 만들기 위한 인명구조장비 위치 공유 웹사이트를 개발하였습니다.
 
 
**주제** 
 - 안전한 해양레저 관광지 추천을 위한 바닷가 인명구조장비함 위치정보 공유

**프로젝트 기획배경**
 - 최근 국민의 여가활동에 대한 관심과 수준이 높아지면서 해양레저를 찾는 사람이 무척 증가하였습니다.
 - 이에 따라, 바다를 찾는 관광객들이 물에 빠져 크게 다치거나 사망하는 사고 사례를 빈번히 찾아볼 수 있게 되었습니다.

**기대효과**
- 안전한 관광지를 찾는 레저객들에게 인명구조장비함이 가까운 장소를 알려주고, 관광지를 홍보할 수 있습니다.
- 예기치 못한 사고가 발생했을 때 인명구조장비함을 빠르게 찾을 수 있다면 위급한 생명을 구할 수 있을 것입니다.
- 위와 같은 서비스로 해양레저산업의 발전과 안전한 해양레저활동을 더욱 촉진시킬 수 있을 것입니다.

**구성**
프로젝트는 두가지로 구성되어 있습니다.
- 1. 인명구조장비함을 찾아서 등록할 수 있는 모바일앱
- 2. 등록된 인명구조장비함을 지도와 함께 공유하고 확인할 수 있는 웹사이트

사용한 기술
- 모바일앱 : Java, Kotlin
- 웹사이트 : Java, Java Script


**서비스 간략 흐름**
> ① 기초데이터 수집
- 위치정보 수집 모바일 앱을 통해 유저들이 인명구조함 정보(사진,위도,경도)를 수집합니다.
- 세부내용은 깃허브 참고 : 소스코드 https://github.com/tmdduq/publicDB
- ![image](https://user-images.githubusercontent.com/7472841/205048566-19b8d0f9-bb90-4d5a-a2ff-fe2914ef3db8.png)


> ② 데이터 분석 및 융합
- 수집한 인명구조함/구역 정보와 해양경찰청에서 제공하는 구역 정보를 분석하여 융합합니다.
- 구역정보: 연안체험활동 종합정보시스템 https://imsm.kcg.go.kr/CSMS/sif/sifRiskListRB.do
- 방법 : 인명구조함 위치가 구역정보 다각형 안에 존재하면 매핑

> ③ Javascript 기반의 웹 개발 (API연계)
- 카카오에서 서비스하는 카카오지도 API를 연계하여 지도를 표출합니다.
- 참고 : https://apis.map.kakao.com/web/, 소스코드 https://github.com/tmdduq/publicDB_WEB
- ![image](https://user-images.githubusercontent.com/7472841/205049067-f9fab27e-823d-456b-bbe5-564b848e6f7c.png)

> ④ S/W실무과정에서 배운 Promise, Fetch 등 비동기 처리방식을 활용하여 대용량 Json 정보를 지도에 표출
- 클러스터링기법 API를 사용하여 간단한 분포 분석을 병행하였습니다.
- ![image](https://user-images.githubusercontent.com/7472841/205049919-333698ac-f4b7-41ee-bf8a-d3ef479baec6.png)


> ⑤ 국민 누구나 접속하여 안전한 해양관광지를 찾을 수 있도록 웹사이트를 개방
- 바로가기 : http://112.221.55.117:21210/ljh_pictures/displayMap.jsp

> ⑥ 더 좋은 아이디어와 함께 발전시키고, 데이터 산업의 활성화를 위해 원본데이터는 API형태로 제공
- http://112.221.55.117:21210/ljh_pictures/getPoint.jsp




프로젝트 발전 가능성
- 간단하게 지도를 표출하는 페이지 하나를 개발하였으나, 원본데이터가 5,000건 이상으로 방대하기 때문에
   1. 인명구조장비함 분포 분석
   2. 인명구조장비함 설치위치 최적화 분석
   3. 레저객 분포에 따른 안전시설물 현황 분석
- 등 다양한 분석에 활용할 수 있습니다.

- 또한 안전한 관광지를 추천해 주는 여행안내 어플리케이션 등을 주제으로 사업화하여 활용할 수 있습니다.

- 데이터를 활용하기 쉽게 API형태로 제공하도록 개발하였기 때문에 네이버지도, 카카오지도 등 지도어플리케이션에서도 안전정보 주제도를 연계할 수 있습니다.
