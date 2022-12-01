<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%><%@ 
	page import="java.sql.*, java.util.*, ljh_pictures.*"%><%
		request.setCharacterEncoding("utf-8");
		Utils ut = new Utils(Utils.currentYEAR);	
		final String TAG = ut.getClientIP(request) +"\tsaveValues.jsp";
	
		String timeStamp = new String(request.getParameter("timeStamp"));
		String add = new String(request.getParameter("add"));
		String latitude = new String(request.getParameter("latitude"));
		String longitude = new String(request.getParameter("longitude"));
		String form1 = new String(request.getParameter("form1"));
		String form2 = new String(request.getParameter("form2"));	
		String form3 = new String(request.getParameter("form3"));
		try{
			form3 = form3.replaceAll(",", "");
		}catch(Exception e){}
		String form4 = new String(request.getParameter("form4"));
		int num = Utils.getC();
		String form4_check;
		try{
			form4_check = new String(request.getParameter("form4_check"));
		}catch(Exception e){form4_check = "X";}
		String phoneNo = new String(request.getParameter("phoneNo"));
		String phoneName = new String(request.getParameter("phoneName"));
		String imageName = new String(request.getParameter("imageName"));
		int flag=0;
		String logg="";	

		Class.forName(ut.getJdbc_forName());
		Connection conn = null;
		PreparedStatement pstmt = null;

		Statement stmt = null;
		ResultSet rs = null;
		String qryForm = "insert";
		try {
//////////////////return;	
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
//			System.out.println("saveValues - db connect");
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select imageName from "+ut.getTable_appdata()+" where imageName='"+imageName+"';");

			if(rs.next()) qryForm = "replace";
	
			pstmt = conn.prepareStatement(qryForm+
					" into "+ut.getTable_appdata()+"(uploadTime, address,latitude,longitude,form1,form2,form3,form4,form4_check,phoneNo,phoneName,imageName, num)"
					+" values(?,?,?,?,?,?,?,?,?,?,?,?,?) ");
			pstmt.setString(1, timeStamp);
			pstmt.setString(2, add);
			pstmt.setString(3, latitude);
			pstmt.setString(4, longitude);
			pstmt.setString(5, form1);
			pstmt.setString(6, form2);
			pstmt.setString(7, form3);
			pstmt.setString(8, form4);
			pstmt.setString(9, form4_check);
			pstmt.setString(10, phoneNo);
			pstmt.setString(11, phoneName);
			pstmt.setString(12, imageName);
			pstmt.setInt(13, num);
			pstmt.executeUpdate();
			flag=10;
			System.out.print(ut.getTimestamp(TAG)+"쓰기 : ");
			} catch (SQLException e) {
				flag=20;
				logg +=e;
				System.out.println(ut.getTimestamp(TAG)+"에러 : "+ e+"\n  " );
				e.printStackTrace();
			} finally {
				if (pstmt != null)
					try {
						pstmt.close();
					} catch (Exception e) { }
				if (conn != null)
					try {conn.close();
					} catch (Exception e) {  }
			}
		System.out.print("(n)"+num);
		System.out.print("(ti)"+timeStamp);
		System.out.print(" (ad)"+add);
		System.out.print(" (lat)"+latitude);
		System.out.print(" (lon)"+longitude);
		System.out.print(" (f1)"+form1);
		System.out.print(" (f2)"+form2);
		System.out.print(" (f3)"+form3);
		System.out.print(" (f4)"+form4);
		System.out.print(" (po)"+phoneNo);
		System.out.println(" (fNa)"+imageName);
		
		
	%><%= flag %>

<p><p><p>code 0 : nothing operation.
<p>code 9 : Successful 
<p>code 20 : fail
<%= logg %>
