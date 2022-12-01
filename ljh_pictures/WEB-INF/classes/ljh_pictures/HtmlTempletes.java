package ljh_pictures;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class HtmlTempletes{
	
	/*
		table.add(new String[]{"기획", "위원회 사진", "담당부서;부처명;사진설명;참고사항", "String;List$행안부$기재부$경찰청$해수부;String;TextArea"});
		table.add(new String[]{"안전", "연안안전지키미", "시설명;구역;내용;파손여부", "List$방파제$CCTV$해수욕장;List$연안사고 다발구역$사망사고 발생구역$통제구역;String;List$O$X"});
		table.add(new String[]{"경비", "중국어선", "어선종류;어선명;MMSI", "List$자망$선망$트롤$주광;String;String"});
	*/	
	
	public String makeMainTable(String gubun) {
		try {
			Utils ut = new Utils(Utils.currentYEAR);	
			Class.forName(ut.getJdbc_forName());
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			conn = DriverManager.getConnection(ut.getJdbc(), ut.getJdbc_id(), ut.getJdbc_pw());
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select v3,v4 from researchform where v2='"+gubun+"';");
			
			String[] labels;
			String[] types;
			if(rs.next()) {
				labels = rs.getString(1).split(";");
				types = rs.getString(2).split(";");
			}
			else return null;
			
			StringBuilder sb = new StringBuilder();
			sb.append("<table style=\"width: 97%;text-align:-webkit-center; margin-left: 3%;\">\n");
			sb.append("\t\t\t\t\t<colgroup>");
			sb.append("\t\t\t\t\t\t<col style=\"width: 10%;\">\n");
			sb.append("\t\t\t\t\t\t<col style=\"width: 40%;\">\n");
			sb.append("\t\t\t\t\t\t<col style=\"width: 40%;\">\n");
			sb.append("\t\t\t\t\t</colgroup>\n");
			sb.append("\t\t\t\t\t<tbody>\n");
					
			for(int i = 0; i< labels.length ; i++) {
				if(types[i].contains("String")) {
					sb.append("\t\t\t\t\t\t<tr>\n");
					sb.append("\t\t\t\t\t\t\t<th><label>"+labels[i]+"</label></th>\n");
					sb.append("\t\t\t\t\t\t\t<td colspan='2'><input type='text' class='form-control' name='input"+i+"' style='width:85%; margin-left:3%;' placeholder='-' required ></td>\n");
					sb.append("\t\t\t\t\t\t</tr>\n");
					sb.append("\t\t\t\t\t\t<tr>\n");
				}
				if(types[i].contains("List")) {
					String[] options = types[i].split("\\$");
					sb.append("\t\t\t\t\t\t<tr>\n");
					sb.append("\t\t\t\t\t\t\t<th><label>"+labels[i]+"</label></th>\n");
					sb.append("\t\t\t\t\t\t\t<td colspan='2'><select name='input"+i+"' class='form-control' style='width:88%; margin-left:3%;' onchange='selected(this)'>\n");
					for(int j=1 ; j< options.length ; j++) 
						sb.append("\t\t\t\t\t\t\t\t\t<option value='"+options[j]+"'>"+options[j]+"</option>\n");
					sb.append("\t\t\t\t\t\t\t</select></td>\n");
					sb.append("\t\t\t\t\t\t</tr>\n");
				}
				if(types[i].contains("TextArea")) {
					sb.append("\t\t\t\t\t\t<tr>\n");
					sb.append("\t\t\t\t\t\t\t<th><label>"+labels[i]+"</label></th>\n");
					sb.append("\t\t\t\t\t\t\t<td colspan='2'><textarea class='form-control' name='input"+i+"' style='width:86%;margin-left:3%;border: 3px solid #3c5a8c;border-radius: 10px;' placeholder='long text ' required ></textarea></td>\n");
					sb.append("\t\t\t\t\t\t</tr>\n");		
				}
			}
			sb.append("\t\t\t\t\t</tbody>\n");
			sb.append("\t\t\t\t\t\n");
			sb.append("\t\t\t\t</table>\n");
			sb.append("<input name='gubun' type='text' style='display:none;' value='"+gubun+"'> ");
			return sb.toString();	
		}catch(Exception e) {
			e.printStackTrace(); 
			return null;
			}
		
	}
	
}