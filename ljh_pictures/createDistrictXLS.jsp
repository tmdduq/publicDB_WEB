<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.usermodel.BorderStyle"%>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@ page import="org.apache.poi.ss.usermodel.ClientAnchor"%>
<%@ page import="org.apache.poi.ss.usermodel.ClientAnchor.AnchorType"%>
<%@ page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@ page import="org.apache.poi.ss.usermodel.Font"%>
<%@ page import="org.apache.poi.ss.usermodel.HorizontalAlignment"%>
<%@ page import="org.apache.poi.ss.usermodel.Picture"%>
<%@ page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import="org.apache.poi.ss.util.WorkbookUtil"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="ljh_pictures.*"%>
<%

	String targetName= "";
	try{
		String s = new String(request.getParameter("targetName"));
		if(s!=null) targetName = s; 
	}catch(Exception e){}
	String[] targets = new String[]{targetName};
	
	String year= "";
	try{
		String s = new String(request.getParameter("year"));
		if(s!=null) year = s; 
	}catch(Exception e){year=""+Utils.currentYEAR;}
	Utils ut = new Utils(Integer.parseInt(year));
	
	
	if(targetName.matches("본청")) targetName = "";
	String qryTargetName="";	
	if(targetName.length()>0){
		if(targetName.endsWith("서")) targets = ut.upperName(targetName, Utils.S2P);
		
		else if(targetName.endsWith("지방청")) targets = ut.upperName(targetName, Utils.Ch2P);
		
		qryTargetName = " where pname like '" + targets[0] +"%'";
		for(int i =1 ; i< targets.length ; i++)
			qryTargetName += " or pname like '" + targets[i] +"%'";
	}
	qryTargetName+=";";
	String fullQuery = "select * from "+ut.getTable_district() + qryTargetName;
	
	
	final String TAG = ut.getClientIP(request) + "\tcreateDistrictXLS.jsp";
	StringBuilder log = new StringBuilder(ut.getTimestamp(TAG)+"Log\n<p>");
	String path = "";
	HSSFWorkbook wb = null;
	HSSFSheet sheet = null;
	FileOutputStream fout = null;
	
	int rowCount = 1;
	int totalSize=0;
	
	try {
		wb = new HSSFWorkbook();
		HSSFRow row;
		HSSFCell cell;
//		HSSFSheet sheet;	

		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
	
		String sheetName = WorkbookUtil.createSafeSheetName("조사결과");
		sheet = wb.createSheet(sheetName);
		Font fontTitle = wb.createFont();
		fontTitle.setFontHeightInPoints((short) 15);
	
		CellStyle styleTitle = wb.createCellStyle();
		styleTitle.setAlignment(HorizontalAlignment.CENTER);
		styleTitle.setBorderTop(BorderStyle.THIN);
		styleTitle.setBorderBottom(BorderStyle.THIN);
		styleTitle.setBorderLeft(BorderStyle.THIN);
		styleTitle.setBorderRight(BorderStyle.THIN);
		styleTitle.setFont(fontTitle);
	
		CellStyle styleHeader = wb.createCellStyle();
		styleHeader.setBorderTop(BorderStyle.THIN);
		styleHeader.setBorderBottom(BorderStyle.THIN);
		styleHeader.setBorderLeft(BorderStyle.THIN);
		styleHeader.setBorderRight(BorderStyle.THIN);
		styleHeader.setAlignment(HorizontalAlignment.CENTER);
		styleHeader.setWrapText(true);
	
		CellStyle timeStyle = wb.createCellStyle();
		timeStyle.setDataFormat(wb.getCreationHelper().createDataFormat().getFormat("yyyy-MM-dd HH:mm:ss"));
		timeStyle.setBorderTop(BorderStyle.THIN);
		timeStyle.setBorderBottom(BorderStyle.THIN);
		timeStyle.setBorderLeft(BorderStyle.THIN);
		timeStyle.setBorderRight(BorderStyle.THIN);
		timeStyle.setAlignment(HorizontalAlignment.CENTER);
		timeStyle.setWrapText(true);
	
		row = sheet.createRow(0);
		ut.input(row, 1, styleTitle, "연번");
		ut.input(row, 2, styleTitle, "시간");
		ut.input(row, 3, styleTitle, "파출소명");
		ut.input(row, 4, styleTitle, "장소명");
		ut.input(row, 5, styleTitle, "구역구분");
		ut.input(row, 6, styleTitle, "장소형태");
		ut.input(row, 7, styleTitle, "주소");
		ut.input(row, 8, styleTitle, "공간정보(좌표)");
		ut.input(row, 9, styleTitle, "공간정보(좌표)");
		ut.input(row, 10, styleTitle, "공간정보(시스템용)");
	
		Class.forName(ut.getJdbc_forName());
		conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
	
//		System.out.println("connect ");
		stmt = conn.createStatement();
		rs = stmt.executeQuery(fullQuery);
	
		System.out.println(ut.getTimestamp(TAG)+"엑셀기록 시작");
//		System.out.printf("%-20s %-40s %-12s %-12s %-15s %-20s %-20s %-20s %s\n", "업로드시간", "주소", "위도", "경도", "시설", "위치", "설명", "휴대폰번호", "이미지명");
		
		rowCount = 1;
		while (rs.next()) {
//			System.out.printf("%-20s %-40s %-12s %-12s %-15s %-20s %-20s %-20s %s\n", rs.getString("uploadTime"),
//			rs.getString("address"), rs.getString("latitude"), rs.getString("longitude"), rs.getString("form1"),
//			rs.getString("form2"), rs.getString("form3"),rs.getString("phoneNo"),rs.getString("imageName"));
			if(rowCount % 500 ==0) System.out.println(ut.getTimestamp(TAG)+"엑셀기록중..."+(rowCount));
	
			row = sheet.createRow(rowCount);
			ut.input(row, 1, styleHeader, "" + (rowCount));
			try {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
				Date date = sdf.parse(rs.getString("upTime"));
				sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				ut.input(row, 2, timeStyle, sdf.format(date));
			} catch (Exception e) {
				log.append("e Error: "+ rowCount+ e +"\n<p>");
			}
	
			try {
				ut.input(row, 3, styleHeader, rs.getString("pname"));
				ut.input(row, 4, styleHeader, rs.getString("name"));
				ut.input(row, 5, styleHeader, rs.getString("type"));
				ut.input(row, 6, styleHeader, rs.getString("placeType"));
				ut.input(row, 7, styleHeader, rs.getString("address"));
				String point_temp =  rs.getString("point");
				ut.input(row, 8, styleHeader, "우측 "+  (point_temp.chars().filter(c-> c=='/').count()+1)+"개 좌표점을 잇는 내측구역" );
				ut.input(row, 9, styleHeader, point_temp.replaceAll("/","\n"));

				StringBuilder sbt = new StringBuilder( "POLYGON((" );
				for( String pt : point_temp.split("/")){
					String[] pt2 = pt.split(",");
					if(pt2.length < 1) break;
					sbt.append(pt2[1]+" "+pt2[0]+", ");
				}
				sbt.setLength(sbt.length()-1);
				sbt.append("))");
				ut.input(row, 10, styleHeader, sbt.toString() );

			} catch (Exception e3) {
				log.append("e3 Error : " + rowCount + e3+"\n<p>");
			}
			rowCount++;
		} //end while
			for (int i = 0; i < 10; i++) {
				sheet.autoSizeColumn(i);
				try{
					sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512);
				}catch(Exception e){}
			}
	
			String s = new SimpleDateFormat("yyyy-MM-dd-HHmmss_").format(new Date());
			String outputFilePath = ut.getDir_XLS()+"/" + s + (rowCount - 1) + "districtSet.xls";
			fout = new FileOutputStream(outputFilePath);
			wb.write(fout);
			path = ut.getDir_rel_XLS()+"/" + s + (rowCount - 1) + "districtSet.xls";
			System.out.println(ut.getTimestamp(TAG)+"파일로 저장하는 중.. : "+path);
		} catch(Exception e) {
			System.out.println(ut.getTimestamp(TAG)+"에러(totaly) : "+e);
			log.append("Exception- " + e);
			e.printStackTrace();
		} finally {
			try {
				if (fout != null)
				fout.close();
				System.out.println(ut.getTimestamp(TAG)+"엑셀기록 완료 ("+(rowCount-1)+"set)");
			} catch (IOException e) {
				log.append("IO Exception- " + e);
				e.printStackTrace();
			}
		 }
	
	new Xls2Csv(request).xls2csv(ut.getDir_XLS(), ut.getDir_CSV()); // create CSV
%>

<!-- <META HTTP-EQUIV="refresh" CONTENT="1; url=<%=path%>"> -->
<link rel="stylesheet" href="css/xlsdownload/font-awesome.min.css">
<p></p>
	<button
		style="background-color: #04AA6D; border: none; color: white; padding: 12px 16px; font-size: 30px; width: 90%; height: 30vh;"
		   onclick="location.href='<%=path%>'">
		<h id="textView">엑셀 다운로드 완료! <br>클릭하여 다운로드하세요. </h>
	</button>
<p><font color="red"> 카카오 정책상 지도 이미지를 자동으로 캡처해서 제공하는 것은 불법입니다. 텍스트로만 다운로드가 가능한 점 양해바랍니다.</font></p>
<p><%=log.toString()%> </p>
	<button onclick="location.href='<%=path.replace("XLS", "CSV").replace("xls","csv")%>'"> CSV로 받기</button>
