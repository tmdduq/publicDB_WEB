<%@ page pageEncoding="UTF-8"%><%@
page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%><%@
page import="com.oreilly.servlet.MultipartRequest"%><%@
page import="java.awt.image.BufferedImage"%><%@ 
page import="java.io.ByteArrayOutputStream"%><%@
page import="ljh_pictures.*"%><%@ 
page import="java.io.File"%><%@ 
page import="javax.imageio.ImageIO"%><%

	int flag = 0;
	Utils ut = new Utils(Utils.currentYEAR);
	final String TAG = ut.getClientIP(request) +"uploadImage.jsp";
	final String dir = ut.getDir_PICTURE();
	final String resizeDir = ut.getDir_PICTURE_resize();
	String fileName=null;
	//String dir = application.getRealPath("./");
	try {
		int max = 10 * 1024 * 1024; 
		//최대크기, dir 디렉토리에 파일을 업로드하는 multipartRequest
	
		MultipartRequest mr = new MultipartRequest(request, dir, max, "UTF-8");
		String orgFileName = mr.getOriginalFileName("uploaded_file");
		String saveFileName = mr.getFilesystemName("uploaded_file");
		
		fileName = saveFileName;
		System.out.println(ut.getTimestamp(TAG) + "저장 : " + orgFileName);
		flag = 1;
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println(ut.getTimestamp(TAG) + "에러 : " + e);
	}
	
	try{
		File f = new File(dir+"/"+fileName);

		BufferedImage img = ut.scale2(dir+"/"+fileName, 100, 100);
        ImageIO.write(img, "jpg", new File(resizeDir+"/"+fileName));
        System.out.println(ut.getTimestamp(TAG) + "Resize 저장 : " + fileName);
        flag = 1;
	}catch(Exception e){
		flag = 0;
		e.printStackTrace();
		System.out.println(ut.getTimestamp(TAG) + "Resize 에러 : " + e);
	}	
%><%=flag%>
