<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ 
page import="java.util.List, org.apache.commons.csv.CSVRecord"%><%@ 
page import="java.sql.*, java.util.*, java.io.*"%><%@ 
page import="ljh_pictures.*"%><%

Connection conn = null;

String year; 
Utils ut;
try{
	year = new String(request.getParameter("year"));
}catch(Exception e){
	year = "2022";
	}

ut = new Utils( Integer.parseInt(year) );
	
final String TAG = ut.getClientIP(request)+"\tgetPoint.jsp";
String targetName= "";
int totalSize=0;
try{
	String s = new String(request.getParameter("targetName"));
	if(s!=null) targetName = s; 
}catch(Exception e){}

int count = 0;
String fullQuery = null;
String[] targets = new String[]{targetName};
try {
	Class.forName(ut.getJdbc_forName());
	conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
	PreparedStatement pstmt = null;
	Statement stmt = null;
	ResultSet rs = null;
	stmt = conn.createStatement();
	
	if(targetName.matches("본청")) targetName = "";
	
	String qryTargetName="";	
	if(targetName.length()>0){		
		if(targetName.endsWith("서")) targets = ut.upperName(targetName, Utils.S2P);
		else if(targetName.endsWith("지방청")) targets = ut.upperName(targetName, Utils.Ch2P);
		qryTargetName = " where phoneName like '" + targets[0] +"%'";
		for(int i =1 ; i< targets.length ; i++)
			qryTargetName += " or phoneName like '" + targets[i] +"%'";
	}
	qryTargetName+=";";
	fullQuery = "select * from "+ut.getTable_appdata() + qryTargetName;
	rs = stmt.executeQuery(fullQuery);
	
	StringBuilder sb = new StringBuilder();
	sb.append("{\n ");
	sb.append("	\"positions\" : [\n  ");

	while (rs.next()) {
		sb.append("		{\n");
		try{
			sb.append("			\"num\" : " + rs.getInt("num") + ",\n");
		}catch(Exception e){
			sb.append("			\"num\" : " + new Random().nextInt(100000) + ",\n");
			}
		sb.append("			\"lat\" : " + rs.getString("latitude") + ",\n");
		sb.append("			\"lon\" : " + rs.getString("longitude") +",\n" );
		sb.append("			\"form1\" : \"" + rs.getString("form1") + "\",\n");
		sb.append("			\"form3\" : \"" + rs.getString("form3") + "\",\n");
		sb.append("			\"phoneName\" : \"" + rs.getString("phoneName").replace("\n"," ") + "\",\n");
		sb.append("			\"form2\" : \"" + rs.getString("form2") + "\",\n");
		sb.append("			\"form4\" : \"" + rs.getString("form4") + "\",\n");
		sb.append("			\"imageName\" : \"" + rs.getString("imageName") + "\",\n");
		sb.append("			\"form4_check\" : \"" + rs.getString("form4_check") + "\",\n");
		sb.append("			\"address\" : \"" + rs.getString("address") + "\",\n");
		sb.append("			\"count\" : " + count++ + "\n");
		sb.append("		},\n");
	
	}

	sb.deleteCharAt(sb.length()-2);
	sb.append("	]\n");
	sb.append("}\n");
	out.print(sb.toString());
	
	System.out.println(ut.getTimestamp(TAG)+fullQuery + "\t"+count + "건");
} catch (Exception e) {
	System.out.println(ut.getTimestamp(TAG)+"Error Query : "+ fullQuery );
	System.out.println(ut.getTimestamp(TAG)+"Error Content : "+ e);
	e.printStackTrace();
	}
%>