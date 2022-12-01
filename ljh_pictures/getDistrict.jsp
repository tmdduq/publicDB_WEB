<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%><%@ page import="java.sql.*, java.util.*, ljh_pictures.*"%><%
		request.setCharacterEncoding("utf-8");
		
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
		final String TAG = ut.getClientIP(request) +"\tgetDistrict.jsp";
		Connection conn = null;
		String fullQuery = null;
		try {	
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
			fullQuery = "select * from "+ut.getTable_district() + qryTargetName;
			
			Class.forName(ut.getJdbc_forName());
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
			PreparedStatement pstmt = null;
			Statement stmt = null;
			ResultSet rs = null;
			stmt = conn.createStatement();
			rs = stmt.executeQuery(fullQuery );

			int count = 0;
			out.println("num,pname,name,distrcitType,placeType,address,pointArray(latlon)");
			while(rs.next()){
				String id = rs.getString("num");
				String pname = rs.getString("pname");
				String name = rs.getString("name");
				String type = rs.getString("type");
				String placeType = rs.getString("placeType");
				String address = rs.getString("address");
				String pointArray = rs.getString("point");
				out.println(
						id + ","+ 
						pname + "," +
						name + "," + 
						type + "," +
						placeType + "," +
						address + "," +
						pointArray);
				count++;
			}
			
			System.out.println(ut.getTimestamp(TAG)+fullQuery+"\t"+count+"건");
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {  }

		} catch (SQLException e) {
			System.out.println(ut.getTimestamp(TAG)+"Error Query : "+ fullQuery );
				System.out.println(ut.getTimestamp(TAG)+"Error Content : "+ e);
				e.printStackTrace();
		} 
	%>