<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Iamge LIST</title>
	</head>

	<body>
	<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page import="java.io.File, java.io.FileOutputStream"%>
	<%@ page import="java.sql.*, java.util.*"%>
	<%@ page import="ljh_pictures.*"%>
	<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
	<%
		Utils ut = new Utils(Utils.currentYEAR);
		final String TAG = ut.getClientIP(request)+"imageFileList.jsp";
		Connection conn = null;
		
		int count = 0;
		
		try {
			Class.forName(ut.getJdbc_forName());
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
		
			PreparedStatement pstmt = null;
			Statement stmt = null;
			ResultSet rs = null;
		
			//	System.out.println("connect ");
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select * from "+ut.getTable_appdata()+";");
			while (rs.next()) {
		%>
		<a href=" <%=ut.getDir_rel_PICTURE()%>/<%=rs.getString("imageName")%>" download>
			<button style="height: 50px; width: 700px; font-size: 20"><%=rs.getString("imageName")%></button>
		</a>
		<br>
		<%
					count++;
				}
				System.out.println(ut.getTimestamp(TAG)+"사진목록조회 : " + count + "건");
			} catch (Exception e) {
				System.out.println(ut.getTimestamp(TAG)+"에러 : " + e);
				e.printStackTrace();
			}
		%>
	</body>
</html>