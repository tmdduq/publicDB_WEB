<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@page import="ljh_pictures.*"%>
<%@ page import="java.io.File"%>
<%@ page import="javax.imageio.ImageIO"%>

<%
	Utils ut = new Utils(Utils.currentYEAR);
	final String TAG = ut.getClientIP(request)+"imageResize.jsp";
	final String dir = ut.getDir_PICTURE();
	final String resizeDir = ut.getDir_PICTURE_resize();
	
	try{
		File f = new File(dir);
		
		int i  = 1;
		int errorCount = 1;
		int len = f.listFiles().length;
		
		for(File file : f.listFiles()){
			try{
				String fileName= file.getName();
				System.out.print(i+++"/"+len +"\t" + fileName);
				BufferedImage img = ut.scale2(dir+"/"+fileName, 100, 100);
		        ImageIO.write(img, "jpg", new File(resizeDir+"/"+fileName));
		        System.out.println("-> resized");
			}catch(Exception e1){
				System.out.println("-> error ("+errorCount+++")");
			}	
		}
		
	}catch(Exception e){
		e.printStackTrace();
		System.out.println(ut.getTimestamp(TAG) + "Resize error : " + e);
	}
	
%>
asd