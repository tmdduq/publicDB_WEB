<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	    <meta charset="utf-8">
	    <title>사진 확인</title>
	</head>

	<style>

		/* 위쪽에 나타나는 popup*/
		.wsPoiHtmlPopupContainerBottomArrow{ 
			background-color:#00000000 !important;
			width: 155px !important; 
			border:0px !important; 
			margin-top: 50px; 
			margin-left:145px;
			}
		.wsPoiHtmlPopupContainerBottomArrow .wsPoiHtmlPopupContentElement::after	{ content: none !important;}
			
		/* 아래쪽에 나타나는 popup */
		.wsPoiHtmlPopupContainerTopArrow{	 
			background-color:#00000000 !important;
			width: 155px !important; 
			border:0px !important; 
			margin-top: -10px; 
			margin-left:145px;
			}
		.wsPoiHtmlPopupContainerTopArrow .wsPoiHtmlPopupContentElement::after		{ content: none !important;}
		
		/* 그냥 */
		.wsPoiHtmlPopupContentElement{ height:40px !important; width:40px !important;}
		
		/* popup close button */
		.wsPoiHtmlPopupCloseButton {
			top: 35px !important; 
			right: 10px !important; 
			text-align: center; 
			z-index:1; 
			height:auto !important; 
			background-color:#fff;
			}
		
		/*image Click*/
		.imageClickButton { 
			position: absolute; 
			top: 64px; 
			left: -134px; 
			width: 95px; 
			height: 95px; 
			opacity:0; 
			border: 0px; 
			pointer-events:all;
			}
		.imageClickButton:hover {cursor: pointer; opacity: 0.3;}

		/* Popup Designe */ 
		.wrap {position: absolute;left: 0;bottom: 40px;width: 300px;height: 140px;margin-left: -144px;text-align: left;overflow: hidden;font-size: 12px;font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;line-height: 1.5;}
		.wrap * {padding: 0;margin-bottom: 1px;}
		.wrap .info {width: 296px;height: 136px;border-radius: 5px;border-bottom: 2px solid #ccc;border-right: 1px solid #ccc;overflow: hidden;background: #fff;}
		.wrap .info:nth-child(1) {border: 2px solid #a17272}
		.info .title {padding: 0 0 0 10px;height: 25px;background: #ffe4c4;border-bottom: 1px solid #ddd;font-size: 18px;font-weight: bold;}
		.wrap:hover {}
		.info .body {position: relative;overflow: hidden; height: 110px;}
		.info .desc {position: relative;margin: 13px 0 0 110px;height: 75px;}
		.desc .ellipsis {overflow: hidden;text-overflow: ellipsis;white-space: nowrap; margin-bottom : 5px;}
		.desc .jibun {font-size: 11px;color: #463c3c;margin-top: -2px;}
		.info .img {position: absolute;top: 4px;left: 5px;width: 100px;height: 100px;border: 1px solid #a17272;color: #888;overflow: hidden;}
	</style>
	
	<body onload="loadMap();">
		<div id="vmap" style="width:100%;height:80vh;"></div>
			<%@ page import="java.util.List, org.apache.commons.csv.CSVRecord"%>
			<%@ page import="java.sql.*, java.util.*, java.io.*"%>
			<%@ page import="ljh_pictures.*"%>
<%
			Connection conn = null;
			Utils ut = new Utils(Utils.currentYEAR);
			final String TAG = ut.getClientIP(request)+"\tvworldTest.jsp";
			String targetName= null; 
			int totalSize=0;
			try{
				targetName = new String(request.getParameter("targetName"));
			}catch(Exception e){targetName = "";}
			try{
				String year = new String(request.getParameter("year"));
				if(year.contains("2021"))
				ut = new Utils(2021);
			}catch(Exception e){}
			int count = 0;		
			try {
				Class.forName(ut.getJdbc_forName());
				conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
			
				PreparedStatement pstmt = null;
				Statement stmt = null;
				ResultSet rs = null;
	
				stmt = conn.createStatement();
				String qryTargetName="";	
				if(targetName== "" ) qryTargetName ="";
				else{
					String[] t = new String[]{targetName};
					if(targetName.endsWith("경찰서")) t = ut.upperName(targetName, Utils.S2P);
					if(targetName.endsWith("경찰청")) t = ut.upperName(targetName, Utils.Ch2P);
					qryTargetName = " where phoneName='" + t[0]+"'";
					for(int i =1 ; i< t.length ; i++)
						qryTargetName += " or phoneName='" + t[i]+"'";
					qryTargetName+=";";
				}
				rs = stmt.executeQuery("select count(*) from "+ut.getTable_appdata() + qryTargetName);
				System.out.println(ut.getTable_appdata());
				if(rs.next()) totalSize = rs.getInt(1);
				rs = stmt.executeQuery("select * from "+ut.getTable_appdata() + qryTargetName);
	
				String pAddr[] = ut.getpAddress(targetName);
				if(pAddr==null) pAddr = new String[]{"37.393361", "126.649028"};
	%>
	
				<script type="text/javascript" src="http://map.vworld.kr/js/webglMapInit.js.do?version=2.0&apiKey=98BF4BCE-37A5-3D4C-AA39-0AFBCAC7002E"></script>
				<script type="text/javascript">
					var map3d;	  
					function loadMap(){		 
						console.log('loadMap() gogo');
		   	    		var mapOptions = new vw.MapOptions(
		   	        		vw.BasemapType.GRAPHIC,
		   	        		"",
		   	        		eval("vw.DensityType.BASIC"),
		   	        		eval("vw.DensityType.BASIC"),
							false,
							new vw.CameraPosition(
								new vw.CoordZ(127.425, 38.196, 13487000),	//x,y,z
								new vw.Direction(0, -90, 0)		//
	   	            		),
							new vw.CameraPosition(
								new vw.CoordZ(126.97005361917438, 37.513398668248875, 5000),	//seoul
								new vw.Direction(0, -60, 0)	// 
	   	           			)
	   	        		);
	   	   	 			map3d = new vw.Map( "vmap" , mapOptions );
	   	  				console.log('loadMap() end end');
	   	  				
	   	  				
					}

				function abc2(){
		           fetch('getPoint.jsp')
                                .then(function(response){
                                        return response.json();
                                })
                                .then(function(myJson){
					dataSize1 = myJson.positions.length;
					 var markers = $(myJson.positions).map(function(i, position) {
						displayMarker(
							position.lat,
							position.lon,
                                                        position.form1,
                                                        position.form3,
                                                        position.phoneName,
                                                        position.form2,
                                                        position.form4,
                                                        position.imageName,
                                                        position.form4_check,
                                                        position.address,
                                                        <%=count++%>
						);		
					});
                               });

			}
   
					
			<%} catch (Exception e) {}%>
	
			function displayMarker(latitude, longitude, rndur, position, pName, positionType, tltjf, fileName,check, addr, count){								
				var content =  getContent(rndur,position,pName,positionType,tltjf,fileName,check,addr,latitude,longitude);
				var markerImage = 'css/kakaoMap/' + getMarkerImage(rndur);
				map3d.createMarker("tit2", longitude, latitude, content, markerImage, 300, 200);
			}

			function getMarkerImage(rndur){
				var makerImage;
				if(rndur == '연안사고 다발구역') makerImage= 'marker1.png';
				else if(rndur == '연안사고 위험구역') makerImage= 'marker2.png';
				else if(rndur == '사망사고 발생구역') makerImage= 'marker4.png';
				else makerImage= 'marker5.png';
				return makerImage;
			}
			
			function getContent(rndur, position, pName, positionType, tltjf, fileName, check, addr, lat, lon){
				var c = (check == 'X') ? '' : ' (파손됨)';
				var spAddr = addr.split(' ');
				var addrString ='';
				if(spAddr.length > 3)
					for(var i = 2 ; i < spAddr.length ; i++)
						addrString +=' '+spAddr[i];
				else addrString = addr;
	
				var rndur_type ='';
				if(rndur == '사망사고 발생구역') rndur_type = 'style="background: #ffc4c4;"';
				else if(rndur == '연안사고 위험구역') rndur_type = 'style="background: #c4deff;"';
				var content = '<div class="wrap">' + 
				    '    <div class="info" style="pointer-events:all;">' + 
				    '        <div class="title" '+rndur_type+'>'+rndur+ 
				    '        </div>' + 
				    '        <div class="body">' + 
				    '            <div class="img">' +
				    '                <img src="<%=ut.getDir_rel_PICTURE_resize()%>/'+fileName+'" width="100" height="100">' +
				    '           </div>' + 
				    '            <div class="desc">' + 
				    '                <div class="ellipsis">('+positionType+') '+position+'</div>' +
				    '                <div class="jibun ellipsis">N'+lat+', E'+lon+'</div>' + 
				    '                <div class="jibun ellipsis">'+addrString+'</div>' + 
				    '                <div>'+tltjf + c + '</div>' + 
				    '            </div>' + 
				    '        </div>' + 
				    '    </div>' +    
			    	'</div>';
	    
				var imageView = document.createElement('button');
				imageView.innerHTML = '';
				imageView.classList.add('imageClickButton');
	
				imageView.setAttribute('onclick', " window.open('<%=ut.getDir_rel_PICTURE()%>/"  + fileName + "', 'Detail Picture', 'width=800, height=700, toolbar=no, menubar=no, scrollbars=no, resizable=yes' ) ");
				content += '\n'+imageView.outerHTML;
				//console.log(content);
	    		return content;
			}
			

			function rndur2(){
                        fetch('getDistrict.jsp')
                        .then(function(response){
				var t = response.text();
				console.log( t );
                                return t;
                        })
                        .then(function(myTxt){

                                var list = myTxt.split("\n");
                                dataSize2 = list.length-2;
                                for(var i = 1 ; i <= dataSize2 ; i++){  //i[0] : header, i[size-1] : blankLine
                                        const[id,pName,name,districtType,placeType,address, ...pArray] = list[i].split(",");

                                        var polygonColor;
                                        if(districtType == "연안사고 다발구역") polygonColor = vw.Color.GOLD;
                                else if(districtType == "연안사고 위험구역") polygonColor = vw.Color.RED;
                                else if(districtType == "사망사고 발생구역") polygonColor = vw.Color.AQUA;
                                else  polygonColor = vw.Color.LIME;

                                        var p = (''+pArray).split("/");

                                        var polygonPath = [];

                                        for(var j = 0 ; j <= p.length ; j++){
                                                var tt = p[j%p.length].split(",");
                                                polygonPath.push(new vw.Coord(tt[1],tt[0]));
                                        }

					var polygon = new vw.geom.Polygon(new vw.Collection(polygonPath));
					polygon.setFillColor(polygonColor);
					polygon.create();
		 


                                } // End - for(i)
                        }); // End - .then(function(myTxt)

			} // rndur2 end


			
			function rndur(){
				var ar = new Array();
			<%
			try {        	 
				List<CSVRecord> records = ut.readCSV(ut.getFile_rndur());

				ArrayList<Double[]> matchRndur = new ArrayList<>();
				String prevPoName = "";
				String poName ="";
				double lat =1;
				double lon =2;
				for(int n = 1 ; n< records.size() ; n++ ) {	//draw rndur
					CSVRecord record = records.get(n);
					poName = record.get(0);
					lat = Double.parseDouble(record.get(2));
					lon = Double.parseDouble(record.get(1));                
					int positionType = Integer.parseInt(record.get(4));
					String polygonColor = null;
					if(positionType==0) polygonColor = "vw.Color.GOLD";	
					else if(positionType==1) polygonColor = "vw.Color.RED"; 
					else if(positionType==2) polygonColor = "vw.Color.AQUA"; 
					else polygonColor = "vw.Color.LIME";
					

					if(prevPoName.matches(poName)) matchRndur.add(new Double[]{lat, lon});
					
					else if(prevPoName!=""){
						if(!record.get(3).contains( ut.upperName(targetName,Utils.P2S)[0] )) continue;
				
						for(int i = 0 ; i < matchRndur.size() ; i++){ 
							Double[] p =matchRndur.get(i);
							%>ar.push(new vw.Coord(<%=p[1]%>,<%=p[0]%>));<%
						}%>
						var polygon = new vw.geom.Polygon( new vw.Collection(ar) ); polygon.setFillColor( <%=polygonColor%> ); polygon.create(); var ar = new Array();
						<%	matchRndur = new ArrayList<>();
							matchRndur.add(new Double[]{lat, lon});
					}
					else{
						matchRndur.add(new Double[]{lat, lon});
					}
					prevPoName = poName;
				}				
			}catch(Exception e) {
				System.out.println(ut.getTimestamp(TAG)+"error : "+e);
			}
			%>
		}
		</script>
		<p id="result"></p>
		<input type="button" value="포인트 보기" onclick="abc2();" style="width: 25%; height: 5vh;margin: 1vh; font-size:2em;">
		<input type="button" value="구역 보기" onclick="rndur2();" style="width: 25%; height: 5vh;margin: 1vh; font-size:2em;">
	</body>
</html>