package ljh_pictures;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;

public class Xls2Csv {
	
	Utils ut;
	String clientIP;
	
	public Xls2Csv(HttpServletRequest request) {
		ut = new Utils(Utils.currentYEAR);
		clientIP = ut.getClientIP(request);
	}

	public void xls2csv(String xlsDir, String csvDir) {
		StringBuffer cellDData = new StringBuffer();
		
		StringBuffer[] cellData = new StringBuffer[200];
		for(StringBuffer sb : cellData) sb = new StringBuffer();
		
		String xlsFileName = getLastFile(xlsDir);
		try {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(xlsDir+"/"+xlsFileName));
			workbook.setMissingCellPolicy(Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);

			HSSFSheet sheet = workbook.getSheetAt(0);
			for (int rowIndex = sheet.getFirstRowNum(); rowIndex < sheet.getLastRowNum(); rowIndex++) {
				Cell cell = null;
				Row row = null;

				row = sheet.getRow(rowIndex);
				for (int colIndex = row.getFirstCellNum(); colIndex+1 <= row.getLastCellNum(); colIndex++) {
					cell = row.getCell(colIndex);

//					System.out.println("CELL:-->" + cell.toString());
					try {
						CellType sw = cell.getCellType();
						if (sw.equals(CellType.BOOLEAN)) {
							cellDData.append(cell.getBooleanCellValue() + ",");
//							System.out.println("boo" + cell.getBooleanCellValue());
						}
						if (sw.equals(CellType.NUMERIC)) {
							if (DateUtil.isCellDateFormatted(cell)) {

								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
								String strCellValue = dateFormat.format(cell.getDateCellValue());
								cellDData.append(strCellValue + ",");
							} else {
								System.out.println(cell.getNumericCellValue());
								Double value = cell.getNumericCellValue();
								Long longValue = value.longValue();
								String strCellValue1 = new String(longValue.toString());
								cellDData.append(strCellValue1 + ",");
							}
						}
						if (sw.equals(CellType.STRING)) {
							String out = cell.getRichStringCellValue().getString();
							out.replaceAll("\"", "");
							cellDData.append("\""+cell.getRichStringCellValue().getString() + "\",");
							// System.out.println("string"+cell.getStringCellValue());
						}

						if (sw.equals(CellType.BLANK)) {
							cellDData.append("\"THIS IS BLANK\",");
							System.out.print("THIS IS BLANK");
						}

					} catch (NullPointerException e) {
						System.out.println("nullException" + e.getMessage());
					}

				}
				int len = cellDData.length() - 1;
				cellDData.replace(len, cellDData.length(), "");
				cellDData.append("\n");
			}			
			
			String csvFileName = xlsFileName.replaceFirst("(?s)(.*)" + "xls", "$1" + "csv");
			System.out.println(ut.getTimestamp(clientIP + "\tXls2Csv.java\t")+ csvDir+"/"+ csvFileName);
			FileOutputStream fos = new FileOutputStream(csvDir+"/"+ csvFileName);
			fos.write(cellDData.toString().getBytes());
			fos.close();

		} catch (FileNotFoundException e) {
			System.err.println("Exception" + e.getMessage());
		} catch (IOException e) {
			System.err.println("Exception" + e.getMessage());
		}
	}
	
	public String getLastFile(String dir) {
		try {
			File[] fList = new File(dir).listFiles();		
			Arrays.sort(fList, (o2, o1)->o1.getName().compareTo(o2.getName()));

			return fList[0].getName();
		}catch(Exception e) {
			return null;
		}
	}
}
