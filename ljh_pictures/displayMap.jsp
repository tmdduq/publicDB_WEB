<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<title>사진 확인</title>
	<link rel="stylesheet" href="css/kakaoMap/kakaoMap.css">
	<script src="js/jquery-3.6.1.js"></script>
</head>
<style>
	.popupcontext{
		margin-top: -23px;
		mix-blend-mode: color-dodge;
		color: lemonchiffon;
		text-align:center;
	}
</style>
<body>
	<div id="map" style="width:100%;height:95vh; z-index:1;"></div>
<%@ page import="java.util.List, org.apache.commons.csv.CSVRecord"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ljh_pictures.*"%>
 <%

Connection conn = null;

String year; 
Utils ut;
try{
	year = new String(request.getParameter("year"));
}catch(Exception e){
	year = "2022";
	}

ut = new Utils( Integer.parseInt(year) );
	
final String TAG = ut.getClientIP(request)+"\tdisplayMap.jsp";
String targetName= "";
try{
	String s = new String(request.getParameter("targetName"));
	if(s!=null) targetName = s; 
}catch(Exception e){}

String[] targets = new String[]{targetName};
	String pAddr[] = ut.getpAddress(targetName); // [0]lon,  [1]lat
	int zoomLevel = 7;
	if(pAddr==null || targetName.matches("본청")){
		pAddr = new String[]{"127.5", "35.7"};
		zoomLevel = 12;
	}
%>
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c564f2f817d387b816c247a57ce8463e&libraries=clusterer"></script>
		<script>
			var dataSize1 = 0;
			var dataSize2 = 0;
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    		mapOption = {
				center: new kakao.maps.LatLng(<%=pAddr[1]%>,<%=pAddr[0]%>), // 지도의 중심좌표
				
         		level: <%=zoomLevel%> // 지도의 확대 레벨
    		};
			var map = new kakao.maps.Map(mapContainer, mapOption),
				infowindow = new kakao.maps.InfoWindow({removable: true});
			var mapTypeControl = new kakao.maps.MapTypeControl();
			map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
			
			var clusterer = new kakao.maps.MarkerClusterer({
				map: map,
				averageCenter: true,
				minLevel: 7,
				calculator: [20,50,200,500]
			});			
			clusterer.setMinClusterSize(5);

			fetch('getPoint.jsp?year=<%=year%>&targetName=<%=targetName%>')
				.then(function(response){
					return response.json();
				})
				.then(function(myJson){
					dataSize1 = myJson.positions.length;
					senddata();
					
					var markers = $(myJson.positions).map(function(i, position) {
						var makerImage;
						if(position.form1.indexOf('연안사고 다발구역')!=-1) makerImage= 'marker1.png';
						else if(position.form1.indexOf( '연안사고 위험구역')!=-1) makerImage= 'marker2.png';
						else if(position.form1.indexOf('사망사고 발생구역')!=-1) makerImage= 'marker4.png';
						else makerImage= 'marker5.png';
						
						var mk = new kakao.maps.Marker({
							map: map, 
							position: new kakao.maps.LatLng(position.lat, position.lon),
							image : new kakao.maps.MarkerImage(
									'css/kakaoMap/'+makerImage, 
									new kakao.maps.Size(25, 30), {
										offset: new kakao.maps.Point(13, 30
										)
									}
							) 
						});
						
						var overlay = new kakao.maps.CustomOverlay({
							map: map,
							position: mk.getPosition()       
						});

						var content = document.createElement('div');
						content.innerHTML =  getContent(							
									position.num,
									position.form1,
									position.form3,
									position.phoneName,
									position.form2,
									position.form4,
									position.imageName,
									position.form4_check,
									position.address,
									position.lat,
									position.lon);

						var closeBtn = document.createElement('button');
					    closeBtn.innerHTML = 'X';
					    closeBtn.classList.add('buss');
					    closeBtn.onclick = function () {
					        overlay.setMap(null);
					    };
					    content.appendChild(closeBtn);
					    
						var imageView = document.createElement('button');
					    imageView.innerHTML = '';
					    imageView.classList.add('buss_imageView');
					    imageView.onclick = function () {
							window.open("<%=ut.getDir_rel_PICTURE()%>/"+position.imageName, "Detail Picture", "width=800, height=700, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
					    };
					    content.appendChild(imageView);					    
					    overlay.setContent(content);
		 			    kakao.maps.event.addListener(mk, 'click', function() {
			        		overlay.setMap(map);
			    		});
		 			   overlay.setMap(null);
		 			   return mk;
					});
					clusterer.addMarkers(markers);

				}); // End // .then(function(myJson){
			
			
			fetch('getDistrict.jsp?targetName=<%=targetName%>&year=<%=year%>')
			.then(function(response){
				return response.text();
			})
			.then(function(myTxt){
				
				var list = myTxt.split("\n");
				dataSize2 = list.length-2;
				senddata();
				for(var i = 1 ; i <= dataSize2 ; i++){	//i[0] : header, i[size-1] : blankLine
					const[id,pName,name,districtType,placeType,address, ...pArray] = list[i].split(",");
										
					var polygonColor;
					if(districtType == "연안사고 다발구역") polygonColor = ["#DE392A","#FFA299"];    
			        else if(districtType == "연안사고 위험구역") polygonColor = ["#39DE2A","#A2FF99"]; 
			        else if(districtType == "사망사고 발생구역") polygonColor = ["#7F7F39","#007FA2"];
			        else if(districtType == "출입통제구역") polygonColor = ["#9910A2","#b940c2"];
					 else polygonColor = ["#392ADE","#A299FF"];
					
					var p = (''+pArray).split("/");
					
					var polygonPath = [];
					
					for(var j = 0 ; j <= p.length ; j++){
						var tt = p[j%p.length].split(",");
						polygonPath.push(new kakao.maps.LatLng(tt[0],tt[1]));
					}
					
					var polygon = new kakao.maps.Polygon({
						path:polygonPath, 
						strokeWeight: 3, 
						strokeColor: polygonColor[0], 
						strokeOpacity: 0.8, 
						strokeStyle: 'solid',
						fillColor: polygonColor[1], 
						fillOpacity: 0.3 });
					polygon.setMap(map);	
					
					kakao.maps.event.addListener(polygon , 'click', function(mouseEvent) {
						var polygonColor;
						if(districtType == "연안사고 다발구역") polygonColor = ["#DE392A","#FFA299"];    
				        else if(districtType == "연안사고 위험구역") polygonColor = ["#39DE2A","#A2FF99"]; 
				        else if(districtType == "사망사고 발생구역") polygonColor = ["#DE2A39","#FF99A2"];
				        else if(districtType == "출입통제구역") polygonColor = ["#9910A2","#b940c2"];
						 else polygonColor = ["#392ADE","#A299FF"];
			          	  var conten = '<div class="info" style="width: 240px;">' + 
			              '   <div class="title" style="background:'+polygonColor[1] +'; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">'+pName+id+'.'+districtType+' </div>' +
			              '   <div class="size" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">'+name+'</div>' +
			              '   <div class="size" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">'+ placeType+'</div>' +
			              '   <div class="size" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">'+ address+'</div>' +
			              '   <div class="size"></div>' +
			              '</div>';		
						  infowindow.setContent(conten); 
						  infowindow.setPosition(mouseEvent.latLng); 
						  infowindow.setMap(map);
			         });	
				} // End - for(i)
			}); // End - .then(function(myTxt)
			

			//지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
			var zoomControl = new kakao.maps.ZoomControl();
			map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
			// 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
			kakao.maps.event.addListener(map, 'zoom_changed', function() {        
				var level = map.getLevel();
		    	//var message = '지도 레벨은 ' + level;
		    	//var resultDiv = document.getElementById('result');  
		    	//resultDiv.innerHTML = message;
			});


			function getContent(num, rndur, position, pName, positionType, tltjf, fileName, check, addr, lat, lon){
				var c = (check == 'X') ? '' : ' (파손됨)';

				var rndur_type ='';
				if(rndur.indexOf('사망사고 발생구역')!=-1) rndur_type = 'style="background: #ffc4c4; white-space:normal; height:45px;"';
				else if(rndur.indexOf('연안사고 위험구역')!=-1) rndur_type = 'style="background: #c4deff; white-space:normal; height:45px;"';
				else if(rndur.indexOf('연안사고 다발구역')!=-1) rndur_type = 'style="background: #9b59b6; white-space:normal; height:45px;"';
				else rndur_type = 'style="background: #bdc3c7; overflow:scroll; height:45px;"';
				
				var contents = '<div class="wrap" style="height:160px;">' + 
			    '    <div class="info" style="height:155px;">' + 
			    '        <div class="title" '+rndur_type+'>'+pName+num+'.'+rndur+ 
			    '        </div>' + 
			    '        <div class="body">' + 
			    '            <div class="img">' +
			    '                <img src="<%=ut.getDir_rel_PICTURE_resize()%>/'+fileName+'" width="100" height="100">' +
			    '				<div class="popupcontext">'+tltjf+'</div>' +
			    '           </div>' + 
			    '            <div class="desc" style="margin-top: 5px;">' +
			    '                <div class="ellipsis">'+position+'</div>' +
			    '                <div class="jibun ellipsis">'+positionType+'</div>' +
			    '                <div class="jibun ellipsis">N'+lat+'</div>' +
			    '                <div class="jibun ellipsis">E'+lon+'</div>' +
			    '                <div class="jibun ellipsis">'+addr+'</div>' + 
			    '            </div>' + 
			    '        </div>' + 
			    '    </div>' +    
			    '</div>';
			    return contents;
			}
			
			function createMarkerImage(markerSize, offset, spriteOrigin) {
			    var markerImage = new kakao.maps.MarkerImage(
			        'css/kakaoMap/marker.png', // 스프라이트 마커 이미지 URL
			        markerSize, // 마커의 크기
			        {
			            offset: offset, // 마커 이미지에서의 기준 좌표
			            spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
			            spriteSize: 290 //spriteImageSize // 스프라이트 이미지의 크기
			        }
			    );
			    
			    return markerImage;
			}
			function senddata(){

				var v = dataSize1.toString() + ',' + dataSize2.toString();
				
				try{
					window.sendToNative.sendData(v); // with android
				}catch(e){}	
				try{
					parent.sendData('<%=targetName%>', dataSize1, dataSize2);	// with web
				}catch(e){}	
			}
			
		</script>
		<p id="result"></p>
<!--  		<Button onclick="location.href='board/Board_List.jsp'" style="position:relative; float:left; width:60px; margin-top:-55px; margin-left:8px; height:40px; background-color:white; z-index:2;">의견</Button>-->
		 <Button onclick="location.href='board/Board_List.jsp'" style="position:relative; float:left; margin-top:-55px; margin-left:8px; height:40px; background-color:#ff5c5c; z-index:2;">의견남기기</Button>
	</body>
</html>