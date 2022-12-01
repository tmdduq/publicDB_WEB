<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%><%@ page import="java.sql.*, java.util.*, ljh_pictures.*"%><%
		request.setCharacterEncoding("utf-8");
		Utils ut = new Utils(Utils.currentYEAR);	
		final String TAG = ut.getClientIP(request) +"\tgetRank.jsp";
		String index = new String(request.getParameter("index"));
		
		Class.forName(ut.getJdbc_forName());
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String fullQuery = null;
		try {	
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
			stmt = conn.createStatement();
			if(Integer.parseInt(index)==1){
				fullQuery = "select pname, count(*) as c from "+ut.getTable_district() + " group by pname order by c desc limit 10;";
				rs = stmt.executeQuery(fullQuery);
				out.println("*pname,count");
				while(rs.next()){
					String pname = rs.getString("pname");
					String count = rs.getString("c");
					out.println(pname+","+count);
				}
			}
			if(Integer.parseInt(index)==2){
				fullQuery = "select phoneName, count(*) as c from "+ut.getTable_appdata() + " group by phoneName order by c desc limit 10;";
				rs = stmt.executeQuery(fullQuery);
				out.println("*phoneName,count");
				while(rs.next()){
					String pname = rs.getString("phoneName");
					String count = rs.getString("c");
					out.println(pname+","+count);
				}
			}
			System.out.println(ut.getTimestamp(TAG)+fullQuery);
		} catch (SQLException e) {
			System.out.println(ut.getTimestamp(TAG)+"Error Query\t"+fullQuery);
				System.out.println(ut.getTimestamp(TAG)+"Error Content\t "+ e);
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
	%>