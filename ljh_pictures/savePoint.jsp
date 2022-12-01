<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%><%@ page import="java.sql.*, java.util.*, ljh_pictures.*"%><%
		request.setCharacterEncoding("utf-8");
		Utils ut = new Utils(Utils.currentYEAR);	
		final String TAG = ut.getClientIP(request) +"\tsavePoint.jsp";
	
		String upTime = new String(request.getParameter("upTime"));
		String pname = new String(request.getParameter("pname"));
		String type = new String(request.getParameter("type"));
		String name = new String(request.getParameter("name"));
		try{
			name = name.replaceAll(",", "/");
			name = name.replaceAll("\n", " ");
		}catch(Exception e){}
		String point = new String(request.getParameter("point"));
	
		
		String address, placeType;
		try{
			address  = new String(request.getParameter("address"));
			address = address.replaceAll(",", " ");
		}catch(Exception e){
			address = "";
			
		}
		try{
			placeType  = new String(request.getParameter("placeType"));
		}catch(Exception e){
			placeType = "";
		}
		
		int flag=0;
		String logg="";	

		Class.forName(ut.getJdbc_forName());
		Connection conn = null;
		PreparedStatement pstmt = null;

		Statement stmt = null;
		ResultSet rs = null;
		String qryForm = "insert";
		try {
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
//			System.out.println("saveValues - db connect");
			
			stmt = conn.createStatement();
			pstmt = conn.prepareStatement(qryForm+
					" into "+ut.getTable_district()+"(upTime, pname, type, name, point, address, placeType) values(?,?,?,?,?,?,?) ");
			pstmt.setString(1, upTime);
			pstmt.setString(2, pname);
			pstmt.setString(3, type);
			pstmt.setString(4, name);
			pstmt.setString(5, point);
			pstmt.setString(6, address);
			pstmt.setString(7, placeType);
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
		System.out.print("(ti)"+upTime);
		System.out.print(" (pname)"+pname);
		System.out.print(" (type)"+type);
		System.out.print(" (name)"+name);
		System.out.print(" (address)"+address);
		System.out.println(" (point)"+point);
		
	%><%= flag %>

<p><p><p>code 0 : nothing operation.
<p>code 10 : Successful 
<p>code 20 : fail
<%= logg %>
