<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="ljh_pictures.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
</head>
<body> 
<p>its  Server.
<p><%=new Utils(Utils.currentYEAR).getTimestamp("index page")%>
<%System.out.println(new Utils(Utils.currentYEAR).getTimestamp("index page"));%>
</body>
</html>